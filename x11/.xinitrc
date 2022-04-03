if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile"
else
	. "$HOME/.xprofile"
fi

xrdb $HOME/.Xresources &
xinput set-prop 13 "libinput Accel Speed" -0.85 &

exec dwm
