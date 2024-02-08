{ config, pkgs, ... }:

{
	programs.firefox = {
		enable = true;
		package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
# package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
# forceWayland = true;
# nixExtensions = [
#     (pkgs.fetchFirefoxAddon{
#       name = "Adblock Plus";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3995494/adblock_plus-3.14.2.xpi";
#       sha256 = "sha256-ms63QPWaEPP7nA0b+euLfFfKPpJ2QghbPy3znEs2xw0=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "AdBlock for Firefox";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4014431/adblock_for_firefox-5.2.0.xpi";
#       sha256 = "sha256-DaatU30g8yf1Ek3E8UNvMvEilokCLlg0H6wJKlZU7g8=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "AdGuard AdBlocker";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4012057/adguard_adblocker-4.1.37.xpi";
#       sha256 = "sha256-T81ntGhm38SlJIaUXdXTniADV2Q8fSlFuyrPa3/737M=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Content Farm Terminator";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4017713/content_farm_terminator-5.9.2.xpi";
#       sha256 = "sha256-LQ6h46hR+pOlMzRujghZOPI4ev+X9jPfiuDgboaU4GA=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Custom New Tab Page";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3669474/custom_new_tab_page-1.0.0.xpi";
#       sha256 = "sha256-C5GBsK9RYo8cjk8MKL8fNCseDR5d4Fweeqqzu0dPSBQ=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Enhancer for YouTube";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3964540/enhancer_for_youtube-2.0.115.xpi";
#       sha256 = "sha256-oHKFhK0rNrEK7J6Ff+xHfLzYT5DlKmB3Hrd/j5jjsdc=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "ImageAssistant Batch Image Downloader";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3976583/ia_batch_image_downloader-1.66.6.xpi";
#       sha256 = "sha256-Ks401nYN/E8jxYoeZAOL8AK5tVrqVZrMsy4dAwdlgZs=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Octotree";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3999843/octotree-7.6.1.xpi";
#       sha256 = "sha256-E1tWPPafiIc5RpklXR6CfooVc2RU2qcoAijxE8OPNo0=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Saladict";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3854859/ext_saladict-7.20.0.xpi";
#       sha256 = "sha256-k2CdheMm3oqhMggQjHTHVeXbm0Xc2770cvKMtIcEebY=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Stylus";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3995806/styl_us-1.5.26.xpi";
#       sha256 = "sha256-swsU6cT6DI1JDVfmt9iv5sxx4vRZuXS1xvor+jIhApQ=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "FireShot";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4002435/fireshot-1.11.18.xpi";
#       sha256 = "sha256-Ohoy1iotD7ZwVawIZLrMMSlea/p4aofWnk8gmTave6I=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Tampermonkey";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4009746/tampermonkey-4.18.0.xpi";
#       sha256 = "sha256-CLFSYZtPcV0hety3fLsej89GEOSGIrgNECO998WoeEg=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Tree Style Tab";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4017073/tree_style_tab-3.9.7.xpi";
#       sha256 = "sha256-JzNN4vW9iQFJd1ujso+N3EXpcfHUl0ZuCu3u7F+25qw=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "TST Indent Line";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4003179/tst_indent_line-1.2.1.xpi";
#       sha256 = "sha256-MdDzDw6l1/m6sXeEE8I+/yU2VEAsn8iAfg29W3OJQGI=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "TST Mouse Wheel and Double Click";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3473925/tree_style_tab_mouse_wheel-1.5.xpi";
#       sha256 = "sha256-ybrVH86xjnMjRl/SXdgd98bLP126+Hjcb4ToljxJK7U=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "TWP";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4011167/traduzir_paginas_web-9.6.1.xpi";
#       sha256 = "sha256-PMDBB/aLPEg8fyzxqda3NPy+4nYpEeBTHD7pr9ZDWcE=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "uBlacklist";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4003811/ublacklist-8.0.2.xpi";
#       sha256 = "sha256-FnxO29qYP6F+BIIHcEdCEite6uhIfOsF4eMFJ03qUmo=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "uBlock Origin";
#       url = "https://addons.mozilla.org/firefox/downloads/file/4003969/ublock_origin-1.44.4.xpi";
#       sha256 = "sha256-C+VQyaJ8BA0ErXGVTdnppJZ6J9SP+izf6RFxdS4VJoU=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "User-Agent Switcher and Manager";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3952467/user_agent_string_switcher-0.4.8.xpi";
#       sha256 = "sha256-cjoYRvFlVEuCqX5pAA8l/76d4xLwqTLB9sNeVCQKA+4=";
#     })
#     (pkgs.fetchFirefoxAddon{
#       name = "Vim Vixen";
#       url = "https://addons.mozilla.org/firefox/downloads/file/3845233/vim_vixen-1.2.3.xpi";
#       sha256 = "sha256-j4bHesjmXf0/GjJpC1bOkjGsdobVqGv4Xj1cxaOp6bU=";
#     })
#   ];
	extraPolicies = {
		DisplayBookmarksToolbar = true;
		Preferences = {
			"browser.toolbars.bookmarks.visibility" = "never";
			"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
			"media.ffmpeg.vaapi.enabled" = true;
		};
	};
};
profiles.default = {
	settings = {
		"browser.startup.homepage" = "file://${./homepage.html}";
	};
	userChrome = ''
		/*================== SIDEBAR ==================*/
#sidebar-box,
		.sidebar-panel[lwt-sidebar-brighttext] {
			background-color: var(--base_color1) !important;
		}


	/* The default sidebar width. */
	/* #sidebar-box { */
	/*   overflow: hidden!important; */
	/*   position: relative!important; */
	/*   transition: all 300ms!important; */
	/*   min-width: 60px !important; */
	/*   max-width: 60px !important; */
	/* } */

	/* The sidebar width when hovered. */
	/* #sidebar-box #sidebar,#sidebar-box:hover { */
	/*   transition: all 300ms!important; */
	/*   min-width: 60px !important; */
	/*   max-width: 200px !important; */
	/* } */


	/* only remove TST headers */
#sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
display: none; /* remove sidebar header */
	 border-color: var(--base_color2) !important;
}

/*******************/
.sidebar-splitter {
	/* display: none;  remove sidebar split line */
	min-width: 1px !important;
	max-width: 1px !important;
	border-color: var(--base_color2) !important;
}

/* remove top tabbar */ 
#titlebar { visibility: collapse !important; }


/*================== URL BAR ==================*/
#urlbar .urlbar-input-box {
	text-align: center !important;
}


* {
	font-family: JetBrainsMono Nerd Font Mono !important;
	font-size: 12pt !important;
}

/* #nav-bar { visibility: collapse !important; } */
/* hide horizontal tabs at the top of the window */
#TabsToolbar > * {
visibility: collapse;
}

/* hide navigation bar when it is not focused; use Ctrl+L to get focus */
#main-window:not([customizing]) #navigator-toolbox:not(:focus-within):not(:hover) {
	margin-top: -45px;
}
#navigator-toolbox {
transition: 0.2s margin-top ease-out;
}
'';
userContent = ''
/*hide all scroll bars*/
/* *{ scrollbar-width: none !important } */


* {
	font-family: JetBrainsMono Nerd Font Mono;
}

@-moz-document url-prefix("about:") {
	:root {
		--in-content-page-background: #1E1E2E !important;
	}
}


@-moz-document url-prefix(about:home), url-prefix(about:newtab){

	/* show nightly logo instead of default firefox logo in newtabpage */
	.search-wrapper .logo-and-wordmark .logo {
background: url("${./logo.png}") no-repeat center !important;
	    background-size: auto !important;
	    background-size: 82px !important;
display: inline-block !important;
height: 82px !important;
width: 82px !important;
	}

	body {
		background-color: #000000 !important;
background: url("${./bg.png}") no-repeat fixed !important;
	    background-size: cover !important;
	    --newtab-background-color: #000000 !important;
	    --newtab-background-color-secondary: #101010 !important;
	}

	body[lwt-newtab-brighttext] {
		--newtab-background-color: #000000 !important;
		--newtab-background-color-secondary: #101010 !important;

	}

	.top-site-outer .top-site-icon {
		background-color: transparent !important;

	}

	.top-site-outer .tile {
		background-color: rgba(49, 49, 49, 0.4) !important;
	}

	.top-sites-list:not(.dnd-active) .top-site-outer:is(.active, :focus, :hover) {
background: rgba(49, 49, 49, 0.3) !important;
	}

	.top-site-outer .context-menu-button:is(:active, :focus) {
		background-color: transparent !important;
	}

	.search-wrapper .search-handoff-button{
		border-radius: 40px !important;
		background-color: rgba(49, 49, 49, 0.4) !important;
	}
}
'';
};
};

}
