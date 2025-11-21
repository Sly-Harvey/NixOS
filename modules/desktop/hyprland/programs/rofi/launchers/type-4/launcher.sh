#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-3     style-4

dir="$HOME/.config/rofi/launchers/type-4"
theme='style-4'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
