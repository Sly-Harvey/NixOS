#!/usr/bin/env sh

swww query
if [ $? -eq 1 ] ; then
    swww init
fi
swww img ~/.config/hypr/wallpaper.png
