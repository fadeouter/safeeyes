#!/bin/bash

################################################################
#
#  Safeeyes
#
#  do before use: sudo apt install xdotool feh
#
#  based on https://askubuntu.com/questions/30147/command-to-determine-whether-a-fullscreen-application-is-running
#
################################################################

PAUSE=25					# how long will be break?
DIR="${HOME}/Pictures"				# pics for break slideshow

COUNT=$(ls $DIR -1 | wc -l)
SLIDESHOW=$( expr $PAUSE \/ $COUNT )
input_id=$(xinput --list | grep 'slave  pointer' | grep -v 'Virtual' |  tr '\t' '\n' | grep 'id' | grep  -o '[0-9]*')

fill="#555555"
onoff="transform='translate(370, 0) scale(-1, 1)' fill='green'"
lockfile="${HOME}/.sf-lock"
if [ ! -f "$lockfile" ]; then
	onoff="transform='translate(370, 0) scale(-1, 1)' fill='green'"
else
	onoff="fill='red'"
	fill="#cccccc"
fi

icon=$(echo "<svg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 438.5 438.5'><g fill='$fill'><path d='M409 109.2c-19.5-33.6-46-60.2-79.7-79.8C295.7 9.8 259 0 219.3 0s-76.5 9.8-110 29.4C75.5 49 49 75.6 29.2 109.2 10 142.8 0 179.5 0 219.2c0 39.8 9.8 76.5 29.4 110 19.6 33.7 46.2 60.3 79.8 80 33.6 19.5 70.3 29.3 110 29.3s76.5-9.8 110-29.4c33.7-19.5 60.3-46 80-79.7 19.5-33.6 29.3-70.3 29.3-110 0-39.8-9.8-76.5-29.4-110zm-55.3 188c-14 23.8-32.7 42.6-56.5 56.5-23.8 14-49.8 21-78 21-28 0-54-7-78-21-23.7-14-42.5-32.7-56.4-56.5-14-23.8-20.8-49.8-20.8-78 0-28 7-54 20.8-78 14-23.7 32.7-42.5 56.5-56.4C165 70.8 191 64 219.3 64c28 0 54 7 78 20.8 23.7 14 42.5 32.7 56.4 56.5 14 23.8 21 49.8 21 78 0 28-7 54-21 78z'/><path d='M246.7 109.6h-18.3c-2.7 0-4.8 1-6.6 2.6-1.7 1.7-2.5 4-2.5 6.6v100.5h-64c-2.6 0-4.8.8-6.5 2.5-1.8 1.7-2.6 4-2.6 6.6v18.3c0 2.6.8 4.8 2.6 6.5 1.7 1.7 4 2.6 6.5 2.6h91.4c2.6 0 4.8-1 6.5-2.6 1.8-1.7 2.6-4 2.6-6.5v-128c0-2.6-.8-4.8-2.6-6.5-1.7-1.7-4-2.6-6.5-2.6z'/></g></svg>" | base64 -w 0)
slider=$(echo "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 370 370'><path d='M273 88H97c-53.5 0-97 43.6-97 97s43.5 97 97 97h176c53.5 0 97-43.6 97-97s-43.5-97-97-97zm-117.6 97c0 28.8-23.4 52.2-52.2 52.2-28.8 0-52.2-23.4-52.2-52.2 0-28.8 23.4-52.2 52.2-52.2 28.8 0 52.2 23.4 52.2 52.2z' $onoff /></svg>" | base64 -w 0)

echo "| image=$icon"
echo "---"

do_safeeyes() { 
	WINDOW=$(echo $(xwininfo -id $(xdotool getactivewindow) -stats | egrep '(Width|Height):' | awk '{print $NF}') | sed -e 's/ /x/')
	SCREEN=$(xdpyinfo | grep -m1 dimensions | awk '{print $2}')
if [ "$WINDOW" = "$SCREEN" ]; then
	exit 0
else
	/usr/bin/notify-send --hint int:transient:1 $@ "Break!"
	sleep 3
	declare -a inputs=($input_id); for i in "${inputs[@]}"; do xinput --disable "$i"; done
	feh -F --zoom fill --cycle-once -Yz -D $SLIDESHOW $DIR
	declare -a inputs=($input_id); for i in "${inputs[@]}"; do xinput --enable "$i"; done
fi
} 

if [ ! -f "$lockfile" ]; then
	echo "Enabled | refresh=true bash='touch $lockfile' terminal=false image=$slider"
else
	echo "Disabled | refresh=true bash='rm $lockfile' terminal=false image=$slider"
	do_safeeyes() {
	exit 0
	}
fi

do_safeeyes
