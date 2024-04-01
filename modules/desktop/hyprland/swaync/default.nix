{
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    home.file.".config/swaync/icons/music.png".source = ./music.png;
    home.file.".config/swaync/config.json".text = ''
          {
        "$schema": "/etc/xdg/swaync/configSchema.json",
        "positionX": "right",
        "positionY": "top",
        "control-center-margin-top": 10,
        "control-center-margin-bottom": 10,
        "control-center-margin-right": 10,
        "notification-icon-size": 64,
        "notification-body-image-height": 100,
        "notification-body-image-width": 200,
        "timeout": 10,
        "timeout-low": 5,
        "timeout-critical": 0,
        "fit-to-screen": false,
        "control-center-width": 500,
        "control-center-height": 1032,
        "notification-window-width": 500,
        "keyboard-shortcuts": true,
        "image-visibility": "when-available",
        "transition-time": 200,
        "hide-on-clear": false,
        "hide-on-action": true,
        "script-fail-notify": true,
        "widgets": ["title", "dnd", "volume", "backlight", "notifications", "mpris", "buttons-grid"],
        "widget-config": {
          "title": {
            "text": "Notification Center",
            "clear-all-button": true,
            "button-text": "󰆴 Clear All"
          },
          "dnd": {
            "text": "Do Not Disturb"
          },
          "label": {
            "max-lines": 1,
            "text": "Notification Center"
          },
          "mpris": {
            "image-size": 70,
            "image-radius": 5
          },
          "volume": {
            "label": "󰕾"
          },
          "backlight": {
            "label": "󰃟"
          },
          "buttons-grid": {
            "actions": [
              {
                "label": "󰐥",
                "command": "systemctl poweroff"
              },
              {
                "label": "󰜉",
                "command": "systemctl reboot"
              },
              {
                "label": "󰌾",
                "command": "swaylock"
              },
              {
                "label": "󰍃",
                "command": "hyprctl dispatch exit 0"
              },
              {
                "label": "󰏥",
                "command": "systemctl suspend"
              }
            ]
          }
        }
      }
    '';
    home.file.".config/swaync/style.css".text = ''
          @define-color cc-bg rgba(26, 27, 38, 1);
      @define-color noti-border-color rgba(255, 255, 255, 0.15);
      @define-color noti-bg rgb(17, 17, 27);
      @define-color noti-bg-darker rgb(43, 43, 57);
      @define-color noti-bg-hover rgb(27, 27, 43);
      @define-color noti-bg-focus rgba(27, 27, 27, 0.6);
      @define-color noti-close-bg rgba(255, 255, 255, 0.1);
      @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);
      @define-color text-color rgba(169, 177, 214, 1);
      @define-color text-color-disabled rgb(150, 150, 150);
      @define-color bg-selected rgb(0, 128, 255);

      * {
        font-family: JetBrainsMono NFM SemiBold;
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        opacity: 1;
        background: @noti-bg-darker;
      }

      .notification-row {
        outline: none;
        margin: 0px;
        padding: 0px;
      }

      .notification {
        background: @cc-bg;
        border: 2px solid #34548a;
        border-radius: 5px;
        margin: 3px -2px 3px 0px;
      }

      .notification-content {
        background: @cc-bg;
      }

      .notification-default-action {
        margin: 0;
        padding: 0;
        border-radius: 5px;
      }

      .close-button {
        background: #f7768e;
        color: @cc-bg;
        text-shadow: none;
        padding: 0px;
        border-radius: 5px;
        margin-top: 5px;
        margin-right: 5px;
      }

      .close-button:hover {
        box-shadow: none;
        background: #f7768e;
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-action {
        border: 2px solid #34548a;
        border-top: none;
        border-radius: 5px;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        color: #7aa2f7;
        background: @cc-bg;
      }

      .notification-default-action {
        border-radius: 5px;
        margin: 0px;
      }

      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 7px;
        border-bottom-right-radius: 7px;
      }

      .notification-action:first-child {
        border-bottom-left-radius: 10px;
        background: #1b1b2b;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        background: #1b1b2b;
      }

      .inline-reply {
        margin-top: 8px;
      }

      .inline-reply-entry {
        background: @noti-bg-darker;
        color: @text-color;
        caret-color: @text-color;
        border: 1px solid @noti-border-color;
        border-radius: 5px;
      }

      .inline-reply-button {
        margin-left: 4px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        border-radius: 5px;
        color: @text-color;
      }

      .inline-reply-button:disabled {
        background: initial;
        color: @text-color-disabled;
        border: 1px solid transparent;
      }

      .inline-reply-button:hover {
        background: @noti-bg-hover;
      }

      .image {
        border-radius: 5px;
        margin-right: 10px;
      }

      .summary {
        font-size: 16px;
        font-weight: 700;
        background: transparent;
        color: rgba(158, 206, 106, 1);
        text-shadow: none;
      }

      .time {
        font-size: 16px;
        font-weight: 700;
        background: transparent;
        color: @text-color;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        font-size: 15px;
        font-weight: 400;
        background: transparent;
        color: @text-color;
        text-shadow: none;
      }

      .control-center {
        background: @cc-bg;
        border: 2px solid #34548a;
        border-radius: 5px;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
      }

      .floating-notifications {
        background: transparent;
      }

      .blank-window {
        background: alpha(black, 0.1);
      }

      .widget-title {
        color: #7aa2f7;
        background: @noti-bg-darker;
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        font-size: 1.5rem;
        border-radius: 5px;
      }

      .widget-title>button {
        font-size: 1rem;
        color: @text-color;
        text-shadow: none;
        background: @noti-bg;
        box-shadow: none;
        border-radius: 5px;
      }

      .widget-title>button:hover {
        background: #f7768e;
        color: @cc-bg;
      }

      .widget-dnd {
        background: @noti-bg-darker;
        padding: 5px 10px;
        margin: 5px 10px;
        border-radius: 5px;
        font-size: large;
        color: #7aa2f7;
      }

      .widget-dnd>switch {
        border-radius: 5px;
        background: #7aa2f7;
      }

      .widget-dnd>switch:checked {
        background: #f7768e;
        border: 1px solid #f7768e;
      }

      .widget-dnd>switch slider {
        background: @cc-bg;
        border-radius: 5px;
      }

      .widget-dnd>switch:checked slider {
        background: @cc-bg;
        border-radius: 5px;
      }

      .widget-label {
        margin: 10px 10px 5px 10px;
      }

      .widget-label>label {
        font-size: 1rem;
        color: @text-color;
      }

      .widget-mpris {
        color: @text-color;
        background: @noti-bg-darker;
        padding: 5px 10px;
        margin: 5px 10px 5px 10px;
        border-radius: 5px;
      }

      .widget-mpris>box>button {
        border-radius: 5px;
      }

      .widget-mpris-player {
        padding: 5px 10px;
        margin: 10px;
      }

      .widget-mpris-title {
        font-weight: 700;
        font-size: 1.25rem;
      }

      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      .widget-buttons-grid {
        font-size: x-large;
        padding: 5px;
        margin: 5px 10px 10px 10px;
        border-radius: 5px;
        background: @noti-bg-darker;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button {
        margin: 3px;
        background: @cc-bg;
        border-radius: 5px;
        color: @text-color;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button:hover {
        background: rgba(122, 162, 247, 1);
        color: @cc-bg;
      }

      .widget-menubar>box>.menu-button-bar>button {
        border: none;
        background: transparent;
      }

      .topbar-buttons>button {
        border: none;
        background: transparent;
      }

      .widget-volume {
        background: @noti-bg-darker;
        padding: 5px;
        margin: 5px 10px;
        border-radius: 5px;
        font-size: 2rem;
        color: #7aa2f7;
      }

      .widget-backlight {
        background: @noti-bg-darker;
        padding: 5px;
        margin: 5px 10px;
        border-radius: 5px;
        font-size: 2rem;
        color: #7aa2f7;
      }
    '';
  };
}
