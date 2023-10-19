#!/bin/sh -e
#
# Dump 2 database and compare them using `apgdiff` tool.
#

PG_DUMP="pg_dump -s"

echo "Dumping $1"
$PG_DUMP -f $1.sql $1

echo "Dumping $2"
$PG_DUMP -f $2.sql $2

apgdiff $1.sql $2.sql
