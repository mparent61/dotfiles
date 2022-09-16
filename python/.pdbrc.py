import pdb


class Config(pdb.DefaultConfig):
    sticky_by_default = True

    # FUTURE: This is for PDB++ >0.10.2
    # pygments_formatter_class = "pygments.formatters.TerminalTrueColorFormatter"
    # pygments_formatter_kwargs = {"style": "solarized-light"}

    # change the color to "inverse" so that all the colors show through
    current_line_color = 7

    # fancy prompt
    prompt = "(PDB++) > "

    editor = "vim"

    # For ITerm/Solarized this is just a dark gray to standout
    filename_color = pdb.Color.green

    use_terminal256formatter = False  # Best for ITerm/Solarized

    def __init__(self):
        try:
            from pygments.formatters import terminal
        except ImportError:
            pass
        else:
            self.colorscheme = terminal.TERMINAL_COLORS.copy()
            self.colorscheme.update(
                {
                    terminal.Keyword: ("darkred", "red"),
                    terminal.Number: ("darkyellow", "yellow"),
                    terminal.String: ("brown", "green"),
                    terminal.Name.Function: ("darkgreen", "blue"),
                    # terminal.Name.Namespace: ("teal", "turquoise"),
                }
            )


## Augment `pdb++` with a `reload` command
#
#  See https://stackoverflow.com/questions/724924/how-to-make-pdb-recognize-that-the-source-has-changed-between-runs/64194585#64194585


def _pdb_reload(pdb, modules):
    """
    Reload all non system/__main__ modules, without restarting debugger.

    SYNTAX:
        reload [<reload-module>, ...] [-x [<exclude-module>, ...]]

    * a dot(`.`) matches current frame's module `__name__`;
    * given modules are matched by prefix;
    * any <exclude-modules> are applied over any <reload-modules>.

    EXAMPLES:
        (Pdb++) reload                  # reload everything (brittle!)
        (Pdb++) reload  myapp.utils     # reload just `myapp.utils`
        (Pdb++) reload  myapp  -x .     # reload `myapp` BUT current module

    """
    import importlib
    import sys

    ## Derive sys-lib path prefix.
    #
    SYS_PREFIX = importlib.__file__
    SYS_PREFIX = SYS_PREFIX[: SYS_PREFIX.index("importlib")]

    ## Parse args to decide prefixes to Include/Exclude.
    #
    has_excludes = False
    to_include = set()
    # Default prefixes to Exclude, or `pdb++` will break.
    to_exclude = {"__main__", "pdb", "fancycompleter", "pygments", "pyrepl"}
    for m in modules.split():
        if m == "-x":
            has_excludes = True
            continue

        if m == ".":
            m = pdb._getval("__name__")

        if has_excludes:
            to_exclude.add(m)
        else:
            to_include.add(m)

    to_reload = [
        (k, v)
        for k, v in sys.modules.items()
        if (not to_include or any(k.startswith(i) for i in to_include))
        and not any(k.startswith(i) for i in to_exclude)
        and getattr(v, "__file__", None)
        and not v.__file__.startswith(SYS_PREFIX)
    ]
    print(
        f"PDB-reloading {len(to_reload)} modules:",
        *[f"  +--{k:28s}:{getattr(v, '__file__', '')}" for k, v in to_reload],
        sep="\n",
        file=sys.stderr,
    )

    for k, v in to_reload:
        try:
            importlib.reload(v)
        except Exception as ex:
            print(
                f"Failed to PDB-reload module: {k} ({v.__file__}) due to: {ex!r}",
                file=sys.stderr,
            )


pdb.Pdb.do_reload = _pdb_reload
