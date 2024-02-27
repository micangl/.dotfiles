#!/bin/bash

# Accepts as input a file path.
file=$1
# The command returns the X Windows id, to eventually embed zathura in tabbed.
# If no instance of tabbed is open, it doesn't return anything.
xid=$(xdotool search --class tabbed)

# If xid contains a value (so, if an instance of tabbed is effectively open),
# opens zathura with the -e switch to embed it in the Window specified by xid.
# The final & is important to detach zathura from the script. Weird behavior
# is to be expected if it's not detached. Note that the double quotes around
# $file are necessary for files with spaces in their path.
if [ $xid ]; then
    zathura "$file" -e $xid &
else
# If no instance of tabbed is already open, open one. The -c switch makes
# tabbed close when the last tab is closed (so that it doesn't stay open with
# no tabs in it). The -d switch detaches tabbed, which only prints its X
# Windows id. Then zathura is opened like in the previous case.
    xid=$(tabbed -d -c)
    zathura "$file" -e $xid &
fi
