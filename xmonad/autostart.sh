# display
# set 144hz
xrandr --output DP-4 --mode 2560x1440 -r 144
nvidia-settings --load-config-only &

# dock
killall polybar
polybar &

# im
fcitx5 &

# notifcator
killall dunst
KILLALL_NOTFICATOR=$?
dunst &

# desktop background
nitrogen --restore & 

# compositor
killall picom
picom -b --xrender-sync-fence &

# file manager daemon
if [ `ps aux | grep "thunar --daemon" | grep -v grep | wc -l` = '0' ]; then
    thunar --daemon &
fi

# power management
xfce4-power-manager &

# network management
if [ `ps aux | grep nm-applet | grep -v grep | wc -l` = '0' ]; then
    nm-applet &
fi

# keyring
if [ -e /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    eval $(shell gnome-keyring-daemon -s) &
fi

xrdb ~/.Xresources
xmodmap ~/.Xmodmap

test $KILLALL_NOTFICATOR -eq 0 && notify-send -i dialog-information restarted "`date`"
