hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("EGL_PLATFORM", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
hl.env("NIXPKGS_ALLOW_UNFREE", "1")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
	hl.exec_cmd(wallpaper)
	hl.exec_cmd(bar)
	hl.exec_cmd("hypridle")
	hl.exec_cmd("swaync")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("wl-paste --type text --watch cliphist store") -- clipboard store text data
	hl.exec_cmd("wl-paste --type image --watch cliphist store") -- clipboard store image data
	hl.exec_cmd("rm '$XDG_CACHE_HOME/cliphist/db'")
	hl.exec_cmd(batterynotify)
	hl.exec_cmd("polkit-agent-helper-1")
end)

hl.config({
	input = (function()
		local t = {
			kb_layout = kbdLayout .. ",ru",
			kb_variant = kbdVariant .. ",",
			repeat_delay = 275,
			repeat_rate = 35,
			numlock_by_default = true,

			follow_mouse = 1,

			touchpad = {
				natural_scroll = false,
			},

			tablet = {
				output = "current",
			},

			sensitivity = 0,
			force_no_accel = true,
		}

		if capslockAsESC then
			t.kb_options = "caps:swapescape"
		end

		return t
	end)(),
	general = {
		gaps_in = 5,
		gaps_out = 8, -- Use 8 for perfect multiple of cell size
		border_size = 2,
		resize_on_border = true,
		layout = "dwindle", -- dwindle, master, scrolling, monocle
		-- allow_tearing = true, -- Allow tearing for games (use immediate window rules for specific games or all titles)
	},
	decoration = {
		shadow = {
			enabled = false,
		},
		rounding = 10,
		dim_special = 0.3,
		blur = {
			enabled = true,
			special = true,
			size = 6, -- 6
			passes = 2, -- 3
			new_optimizations = true,
			ignore_opacity = true,
			xray = false,
		},
	},
	render = {
		direct_scanout = 0, -- 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
	misc = {
		disable_hyprland_logo = true,
		mouse_move_focuses_monitor = true,
		swallow_regex = "^(Alacritty|kitty)$",
		enable_swallow = true,
		vrr = 2, -- enable variable refresh rate (0=off, 1=on, 2=fullscreen only, 3 = fullscreen games/media)
	},
	xwayland = {
		force_zero_scaling = false,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
		new_on_top = true,
		mfact = 0.5,
	},
	binds = {
		workspace_back_and_forth = 0,
		--allow_workspace_cycles=1,
		--pass_mouse_when_bound=0,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
