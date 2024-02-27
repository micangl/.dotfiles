#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# disable touchpad on startup
xinput set-prop "$TOUCHPAD_ID" "Device Enabled" 0
# dual monitor configuration
xrandr --fb 4608x1512 --output eDP --pos 2688x0 --primary --output HDMI-A-0 --pos 0x0 --scale 1.4x1.4 --mode 1920x1080
# map touchscreen input to actual laptop screen framebuffer
xinput --map-to-output "$TOUCHSCREEN_ID" eDP
# set keyboard layouts on startup, and alt+shift to switch between them
setxkbmap -layout us,it -option grp:alt_shift_toggle
# necessary to have the DISPLAY enviroment variable properly set and avoid problems
dbus-update-activation-environment DISPLAY
#dwmblocks &
#blueman-applet &
#nm-applet &
volctl &
dunst &
# sets the window manager name to compiz so that java UIs function properly
# (they won't if they don't recognize the wm name, as for dwm), necessary
# especially for matlab which uses java UI
#wmname compiz
exec awesome
