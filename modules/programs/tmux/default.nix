{
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = _: {
    programs.tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
                	    set -g @catppuccin_flavour 'mocha'
                      set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory user host session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
      ];
      extraConfig = ''
               set -g default-terminal "xterm-256color"
               set -ga terminal-overrides ",*256col*:Tc"
               set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
               set-environment -g COLORTERM "truecolor"
               bind -n M-Left select-pane -L
               bind -n M-Right select-pane -R
               bind -n M-Up select-pane -U
               bind -n M-Down select-pane -D
        # easy-to-remember split pane commands
               bind | split-window -h -c "#{pane_current_path}"
               bind - split-window -v -c "#{pane_current_path}"
               bind c new-window -c "#{pane_current_path}"
               # Shift arrow to switch windows
               bind -n S-Left  previous-window
               bind -n S-Right next-window
               set -g prefix C-a
               bind C-a send-prefix
               unbind C-b
               set -g history-limit 100000
               set -g allow-rename off
               run-shell /opt/tmux-logging/logging.tmux
               # set vi-mode
               set-window-option -g mode-keys vi
               # keybindings
               bind-key -T copy-mode-vi v send-keys -X begin-selection
               bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
               bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
  };
}
