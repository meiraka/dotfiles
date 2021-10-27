
# set display size
# xrandr --newmode "1200x1600R"  134.25  1200 1248 1280 1360  1600 1603 1613 1646 +hsync -vsync
# xrandr --addmode DVI-1 1200x1600R
# xrandr --output DVI-1 --mode 1200x1600R

nvidia-settings --load-config-only &
fcitx-autostart &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
pamac-tray &

# set background
nitrogen --restore & 

# tray
killall trayer
trayer -l --edge top --align left \
    --expand true --widthtype percent --width 10% \
    --tint 0x242424 --transparent true --alpha 10 --height 25 &

killall picom
picom -b &

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
# bluetooth
blueman-applet &


# enabling update manager and ubuntu software center
if [ -e /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & 
    eval $(shell gnome-keyring-daemon -s) &
fi


# enabling pamac
if [ -e /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    eval $(shell gnome-keyring-daemon -s) &
fi

# set touchpad settings
synclient TapButton1=0
synclient TapButton2=0
synclient HorizTwoFingerScroll=1
synclient VertScrollDelta=-70
synclient HorizScrollDelta=-70
synclient VertEdgeScroll=0
synclient HorizEdgeScroll=0
# coasting
synclient CoastingFriction=30
synclient CoastingSpeed=25
xrdb ~/.Xresources
xmodmap ~/.Xmodmap
