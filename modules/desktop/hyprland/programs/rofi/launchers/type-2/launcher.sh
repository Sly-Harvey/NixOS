#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-2     style-13

dir="$HOME/.config/rofi/launchers/type-2"
theme='style-2'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
