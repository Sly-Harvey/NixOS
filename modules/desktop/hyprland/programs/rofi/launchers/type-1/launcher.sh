#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-5     style-6     style-7     style-9

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-5'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
