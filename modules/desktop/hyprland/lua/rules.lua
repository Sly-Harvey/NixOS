-- Rofi
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.7,
})

-- Hyprpanel Menus
hl.layer_rule({
	match = {
		namespace = "^(bar-.*|notifications-window|mediamenu|notificationsmenu|calendarmenu|audiomenu|networkmenu|energymenu|dashboardmenu)$",
	},
	blur = true,
	ignore_alpha = 0.7,
})

-- Swaync
hl.layer_rule({
	match = { namespace = "^(swaync-control-center)$" },
	blur = true,
	ignore_alpha = 0.7,
})
hl.layer_rule({
	match = { namespace = "^(swaync-notification-window)$" },
	blur = true,
	ignore_alpha = 0.8,
})

-- Window Rules

hl.window_rule({
	match = { class = "^([Ff]irefox)$" },
	opacity = "1.00 1.00",
})
hl.window_rule({
	match = { class = "^([Zz]en(-beta|-browser)?)$" },
	opacity = "1.00 1.00",
})
hl.window_rule({
	match = { class = "^([Ff]loorp)$" },
	opacity = "1.00 1.00",
})
hl.window_rule({
	match = { class = "^([Bb]rave-browser(-beta|-dev|-unstable)?)$" },
	opacity = "1.00 1.00",
})
hl.window_rule({
	match = { class = "^(Emacs)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^(gcr-prompter)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { title = "^(Hyprland Polkit Agent)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^(obsidian)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^(proton.vpn.app.gtk)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^(heroic)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^([Ll]utris|net.lutris.Lutris)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" },
	opacity = "0.90 0.80",
})
hl.window_rule({
	match = { class = "^(com.github.rafostar.Clapper)$" },
	opacity = "0.90 0.80",
	float = true,
})
hl.window_rule({
	match = { class = "^(kitty|[Aa]lacritty|org.wezfurlong.wezterm)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(nvim-wrapper)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(gnome-disks)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(org.gnome.Nautilus|[Tt]hunar|pcmanfm)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(thunar-volman-settings)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(file-roller|org.gnome.FileRoller)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(io.github.ilya_zlobintsev.LACT)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^([Ss]team|steamwebhelper)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^([Ss]potify|com.github.th_ch.youtube_music)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { title = "^(Kvantum Manager)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(VSCodium|codium-url-handler)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(code|code-url-handler)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(fileManager)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(org.kde.dolphin)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(org.kde.ark)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(nwg-look)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(qt5ct|qt6ct)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(qt5ct)$" },
	float = true,
})
hl.window_rule({
	match = { class = "^(yad)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(gjs)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(com.github.tchx84.Flatseal)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(hu.kramo.Cartridges)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(com.obsproject.Studio)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(gnome-boxes)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(app.drey.Warp)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(net.davidotek.pupgui2)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(Signal)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(pavucontrol)$" },
	float = true,
})
hl.window_rule({
	match = { class = "^(blueman-manager|.blueman-manager-wrapped)$" },
	opacity = "0.80 0.70",
})
hl.window_rule({
	match = { class = "^(blueman-manager)$" },
	float = true,
})
hl.window_rule({
	match = { class = "^(.blueman-manager-wrapped)$" },
	float = true,
})
hl.window_rule({
	match = { class = "^(nm-applet)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(nm-connection-editor)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
	opacity = "0.80 0.70",
	float = true,
})
hl.window_rule({
	match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde)$" },
	opacity = "0.80 0.70",
})

-- Float Picture-in-Picture window for firefox-based browsers
hl.window_rule({
	match = {
		title = "^(Picture-in-Picture)$",
		class = "^([Zz]en(-beta|-browser)?|[Ff]loorp|[Ff]irefox)$",
	},
	float = true,
	pin = true,
})

hl.window_rule({
	match = { tag = "games" },
	content = "game",
	sync_fullscreen = true,
	fullscreen = true,
	border_size = 0,
	no_shadow = true,
	no_blur = true,
	no_anim = true,
})
hl.window_rule({
	match = { content = "3" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "^(steam_app.*|steam_app_\\d+)$" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "^(gamescope)$" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "(Waydroid)" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "(osu!)" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "^(com.libretro.RetroArch|[Rr]etro[Aa]rch)$" },
	tag = "+games",
})

-- Godot
hl.window_rule({
	match = {
		initial_title = "^(Godot)$",
		initial_class = "^(Godot)$",
	},
	tile = true,
})
hl.window_rule({
	match = {
		title = "^((.*)(DEBUG))",
		class = "^(Godot)$",
	},
	float = true,
})
hl.window_rule({
	match = {
		initial_title = "^(.*)(DEBUG)(.*)$",
		class = "^(Godot)$",
	},
	float = true,
})

hl.window_rule({
	match = { class = "^(microfetch)$" },
	opacity = "0.80 0.70",
	float = true,
	center = true,
	size = "802 261",
})
hl.window_rule({
	match = { class = "^(eog)$" },
	float = true,
})
