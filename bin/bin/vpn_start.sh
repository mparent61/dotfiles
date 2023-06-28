#!/bin/zsh -e
#
# OSX CLI command to connect to VPN and wait until completed.
# #
# Call with <script> "<VPN Connection Name>"
# 
#--------------------------------------------------------------------------------

VPN="$1"

function poll_until_connected () {
    let loops=0 || true
    let max_loops=200 # 200 * 0.1 is 20 seconds. Bash doesn't support floats

    while vpn_isnt_connected; do
        sleep 0.1 # can't use a variable here, bash doesn't have floats
        let loops=$loops+1
        [ $loops -gt $max_loops ] && break
    done

    [ $loops -le $max_loops ]
}

function vpn_isnt_connected() {
    networksetup -showpppoestatus "$VPN" | grep -qvi connected
}

networksetup -connectpppoeservice "$VPN"

if poll_until_connected; then
    echo "Connected to $VPN!"
    exit 0
else
    echo "Took to long to connect, aborting"
    networksetup -disconnectpppoeservice "$VPN"
    exit 1
fi


poll_until_connected
echo "Connected!"
