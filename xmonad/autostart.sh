
# set display size
xrandr --newmode "1200x1600_60.00"  162.25  1200 1288 1416 1632  1600 1603 1613 1658 -hsync +vsync
xrandr --addmode DVI-1 1200x1600_60.00
xrandr --output DVI-1 --mode 1200x1600_60.00

# set background
nitrogen --restore & 

# tray
killall trayer
trayer --edge top --align left --SetDockType true \
    --expand true --widthtype percent --width 10% \
    --tint 0x141414 --transparent true --alpha 0 --height 25 &

# killall compton
# ~/bin/compton -b &

# file manager daemon
if [ `ps aux | grep "thunar --daemon" | grep -v grep | wc -l` = '0' ]; then
    thunar --daemon &
fi

# power management
xfce4-power-manager &


# enabling update manager and ubuntu software center
if [ -e /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & 
    eval $(shell gnome-keyring-daemon -s) &
fi

# set touchpad settings
synclient TapButton1=0
synclient TapButton2=0
synclient HorizTwoFingerScroll=1
synclient VertScrollDelta=-237
synclient HorizScrollDelta=-237
synclient VertEdgeScroll=0
synclient HorizEdgeScroll=0
xrdb ~/.Xresources
xmodmap ~/.Xmodmap
