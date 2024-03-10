{
  config,
  pkgs,
  ...
}: {
  programs.wlogout.enable = true;
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };

  home.file.".config/wlogout/layout".text = ''
    {
    	"label" : "lock",
    		"action" : "swaylock",
    		"text" : "Lock"
    }
    {
    	"label" : "hibernate",
    		"action" : "systemctl hibernate",
    		"text" : "Hibernate"
    }
    {
    	"label" : "logout",
    		"action" : "hyprctl dispatch exit 0",
    		"text" : "Logout"
    }
    {
    	"label" : "shutdown",
    		"action" : "systemctl poweroff",
    		"text" : "Shutdown"
    }
    {
    	"label" : "suspend",
    		"action" : "systemctl suspend",
    		"text" : "Suspend"
    }
    {
    	"label" : "reboot",
    		"action" : "systemctl reboot",
    		"text" : "Reboot"
    }
  '';
  home.file.".config/wlogout/style.css".text = ''
    		* {
    			background-image: none;
    		}
    	window {
    		background-color: transparent;
    	}
    	button {
    color: #53565c;
           background-color: rgba(24, 26, 31, .5);
           border-style: solid;
           border-color: rgba(24, 26, 31, .5);
           border-width: 2px;
           border-radius: 7px;
           background-repeat: no-repeat;
           background-position: center;
           background-size: 25%;
    margin: 10px;
    	}

    button:focus,
    	       button:active,
    	       button:hover {
    		       background-color: rgba(24, 26, 31, .7);
    		       border-color: rgba(24, 26, 31, .7);
    color: #d4d4d6;
           outline-style: none;
    	       }

    #lock {
    	background-image: image(
    			url("./icons/lock.png"),
    			url("/usr/share/wlogout/icons/lock.png"),
    			url("/usr/local/share/wlogout/icons/lock.png")
    			);
    }

    #logout {
    	background-image: image(
    			url("./icons/logout.png"),
    			url("/usr/share/wlogout/icons/logout.png"),
    			url("/usr/local/share/wlogout/icons/logout.png")
    			);
    }

    #suspend {
    	background-image: image(
    			url("./icons/suspend.png"),
    			url("/usr/share/wlogout/icons/suspend.png"),
    			url("/usr/local/share/wlogout/icons/suspend.png")
    			);
    }

    #hibernate {
    	background-image: image(
    			url("./icons/hibernate.png"),
    			url("/usr/share/wlogout/icons/hibernate.png"),
    			url("/usr/local/share/wlogout/icons/hibernate.png")
    			);
    }

    #shutdown {
    	background-image: image(
    			url("./icons/shutdown.png"),
    			url("/usr/share/wlogout/icons/shutdown.png"),
    			url("/usr/local/share/wlogout/icons/shutdown.png")
    			);
    }

    #reboot {
    	background-image: image(
    			url("./icons/reboot.png"),
    			url("/usr/share/wlogout/icons/reboot.png"),
    			url("/usr/local/share/wlogout/icons/reboot.png")
    			);
    }
  '';
}
