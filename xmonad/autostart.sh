# display
xrandr --output DP-0 --mode 3840x2160 -r 100
nvidia-settings --load-config-only &

# compositor
if ! pgrep picom; then
    picom -b &
fi

# dock
killall polybar
polybar &
# /bin/sh -c 'killall trayer; sleep 2 && trayer --edge right --align left --height 50 --distance 50 --transparent true --alpha 255 --iconspacing 12' &

# im
fcitx5 &

# notifcator
killall dunst
KILLALL_NOTFICATOR=$?
dunst &

# desktop background
nitrogen --restore & 

# file manager daemon
if ! pgrep -f "thunar --daemon"; then
    thunar --daemon &
fi

# power management
xfce4-power-manager &

# network management
# if [ `ps aux | grep nm-applet | grep -v grep | wc -l` = '0' ]; then
#     nm-applet &
# fi

# keyring
if [ -e /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    eval $(shell gnome-keyring-daemon -s) &
fi

xrdb ~/.Xresources
xmodmap ~/.Xmodmap

test $KILLALL_NOTFICATOR -eq 0 && notify-send -i dialog-information restarted "`date`"
