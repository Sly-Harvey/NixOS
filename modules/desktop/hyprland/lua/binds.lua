-- Resize windows
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })

-- Resize windows with hjkl keys
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -30 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })

-- Move/Resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Functional keybinds
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 2%-"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +2%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 2"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 2"), { repeating = true })
hl.bind("xf86Sleep", hl.dsp.exec_cmd("systemctl suspend")) -- Put computer into sleep mode
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t")) -- mute mic
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t")) -- mute audio
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause")) -- Play/Pause media
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause")) -- Play/Pause media
hl.bind("xf86AudioNext", hl.dsp.exec_cmd("playerctl next")) -- go to next media
hl.bind("xf86AudioPrev", hl.dsp.exec_cmd("playerctl previous")) -- go to previous media
-- hl.bind("xf86AudioNext", hl.dsp.exec_cmd(mediactrl .. "next")) -- go to next media
-- hl.bind("xf86AudioPrev", hl.dsp.exec_cmd(mediactrl .. "previous")) -- go to previous media
-- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(mediactrl .. "play-pause")) -- go to next media
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd(mediactrl .. "play-pause")) -- go to next media

-- Keybinds help menu
hl.bind(mainMod .. " + question", hl.dsp.exec_cmd(keybinds_yad))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(keybinds_yad))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd(keybinds_yad))

hl.bind(
	mainMod .. " + F8",
	hl.dsp.exec_cmd("kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || " .. autoclicker .. " --cps 40")
)
-- hl.bind(mainMod .. " + ALT + mouse:276", hl.dsp.exec_cmd("kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 60"))

-- Night Mode (lower value means warmer temp)
hl.bind(mainMod .. " + F9", hl.dsp.exec_cmd("hyprsunset --temperature 2500")) -- good values: 3500, 3000, 2500
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("pkill hyprsunset"))

-- Window/Session actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.kill())
hl.bind(mainMod .. " + delete", hl.dsp.exit()) -- kill hyperland session
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" })) -- toggle the window on focus to float
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.group.toggle()) -- toggle the window on focus to group
hl.bind("ALT + return", hl.dsp.window.fullscreen()) -- toggle the window on focus to fullscreen
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock")) -- lock screen
hl.bind(mainMod .. " + backspace", hl.dsp.exec_cmd("pkill -x wlogout || wlogout -b 4")) -- logout menu
hl.bind(
	"CONTROL + ESCAPE",
	hl.dsp.exec_cmd('pkill "waybar|hyprpanel|noctalia-shell|caelestia-shell|.quickshell" || ' .. bar)
) -- toggle bar
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.exec_cmd(zoom .. " in")) -- zoom in
hl.bind(mainMod .. " + CTRL + mouse_up", hl.dsp.exec_cmd(zoom .. " out")) -- zoom out

-- Applications/Programs
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManagerScript .. " " .. fileManager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("youtube-music"))
hl.bind("CONTROL + ALT + DELETE", hl.dsp.exec_cmd(term .. " -e btop")) -- System Monitor
hl.bind("CONTROL + ALT + M", hl.dsp.exec_cmd(term .. ' --class "microfetch" --hold -e microfetch')) -- System Fetch
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("hyprpicker --autocopy --format=hex")) -- Colour Picker

-- Window manager
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(launcher .. " drun")) -- launch desktop applications
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher .. " drun")) -- launch desktop applications
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(launcher .. " wallpaper")) -- launch wallpaper switcher
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(launcher .. " emoji")) -- launch emoji picker
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(launcher .. " tmux")) -- launch tmux sessions
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(launcher .. " games")) -- game launcher
-- hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd(launcher .. " window")) # switch between desktop applications
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(launcher .. " file")) # brrwse system files
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd(keyboardswitch)) -- change keyboard layout
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw")) -- swayNC panel
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("swaync-client -t -sw")) -- swayNC panel
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(gamemode)) -- disable hypr effects for gamemode
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipmanager)) -- Clipboard Manager
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(rofimusic)) -- online music

-- Screenshot/Screencapture
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(screen_record .. " a")) -- Screen Record (area select)
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(screen_record .. " m")) -- Screen Record (monitor select)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(screenshot .. " s")) -- drag to snip an area / click on a window to print it
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(screenshot .. " sf")) -- frozen screen, drag to snip an area / click on a window to print it
hl.bind(mainMod .. " + print", hl.dsp.exec_cmd(screenshot .. " m")) -- print focused monitor
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd(screenshot .. " p")) -- print all monitor outputs

-- to switch between windows in a floating workspace
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch bringactivetotop"))

-- Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "r-1" }))

-- move to the first empty workspace instantly with mainMod + CTRL + [↓]
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + Tab", hl.dsp.focus({ direction = "d" }))

-- Move focus with mainMod + HJKL keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Switch scrolling columns
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg move +col"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg move -col"))

-- Go to workspace 5, 6 and 7 with mouse side buttons
hl.bind(mainMod .. " + mouse:276", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + mouse:275", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + ALT + mouse:275", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + mouse:276", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + mouse:275", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + ALT + mouse:275", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + CTRL + mouse:276", hl.dsp.window.move({ workspace = "5", follow = false }))
hl.bind(mainMod .. " + CTRL + mouse:275", hl.dsp.window.move({ workspace = "6", follow = false }))
hl.bind(mainMod .. " + CTRL + ALT + mouse:275", hl.dsp.window.move({ workspace = "7", follow = false }))

-- Rebuild NixOS with a KeyBind
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd(term .. " -e rebuild"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + left", hl.dsp.window.move({ workspace = "r-1" }))

-- Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
hl.bind(mainMod .. " + SHIFT + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + CTRL + down", hl.dsp.window.move({ direction = "d" }))

-- Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
hl.bind(mainMod .. " + SHIFT + CTRL + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + CTRL + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + CTRL + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + CTRL + J", hl.dsp.window.move({ direction = "d" }))

-- Special workspaces (scratchpad)
hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special", follow = false }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special", follow = false }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("special"))

-- workspaces 1-10
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
