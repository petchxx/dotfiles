#!/bin/bash

sketchybar --add item calendar right \
	--set calendar icon=􀧞 \
	update_freq=1 script="$PLUGIN_DIR/calendar.sh" \
	--set calendar click_script="open -a 'Calendar'"
