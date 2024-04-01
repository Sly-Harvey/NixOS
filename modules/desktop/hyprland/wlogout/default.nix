{
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    programs.wlogout.enable = true;
    #home.file.".config/wlogout/icons" = {
    #	source = ./icons;
    #	recursive = true;
    #};

    home.file.".config/wlogout/layout".text = ''
      {
      	"label" : "shutdown",
      		"action" : "poweroff",
      		"text" : "󰐥",
      		"keybind" : "s"
      }
      {
      	"label" : "reboot",
      		"action" : "reboot",
      		"text" : "󰑓",
      		"keybind" : "r"
      }
      {
      	"label" : "logout",
      		"action" : "hyprctl dispatch exit 0",
      		"text" : "󰗼",
      		"keybind" : "l"
      }
    '';
    home.file.".config/wlogout/style.css".text = ''
      		@define-color fg #ebdbb2;
      	@define-color bg #1d2021;

      	@define-color black #282828;
      	@define-color red #cc241d;
      	@define-color green #b8bb26;
      	@define-color yellow #fabd2f;
      	@define-color blue #83a598;
      	@define-color purple #d3869b;
      	@define-color aqua #8ec07c;
      	@define-color orange #fe8019;

      	window {
      		background-color: rgba(40, 40, 40, 0.5);
      		font-family: Sauce Code Pro NF;
      		font-size: 80px;
      	}

      	grid {
      		border-radius: 30px;
      margin: 200px 400px;
      padding: 10px;
      	 background-color: @bg;
      	}

      	button {
      		border-radius: 20px;
      		border-width: 3px;
      		border-color: @black;
      		outline-style: none;
      margin: 10px;
      padding: 40px;
      	 background-repeat: no-repeat;
      	 background-size: 0%;
      	 background-position: center;
      	 background-color: @black;
      	}

      button:focus,
      	       button:active {
      		       border-color: @color;
      	       }

      #shutdown {
      color: @red;
      }

      #reboot {
      color: @blue;
      }

      #logout {
      color: @green;
      }
    '';
  };
}
