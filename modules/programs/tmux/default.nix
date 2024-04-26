{
  username,
  pkgs,
  ...
}: let
  dreamsofcode-io-catppuccin-tmux =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "catppuccin";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "dreamsofcode-io";
        repo = "catppuccin-tmux";
        rev = "b4e0715356f820fc72ea8e8baf34f0f60e891718";
        sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
      };
    };
in {
  home-manager.users.${username} = _: {
    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      historyLimit = 100000;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        dreamsofcode-io-catppuccin-tmux
        # catppuccin
      ];
      extraConfig = ''
        unbind C-b
        set -g prefix C-a
        bind C-a send-prefix

        set -g @catppuccin_flavour 'macchiato'
        set -g mouse on
        set -g allow-rename off
        set -g status-position top
        set -g base-index 1
        set -g pane-base-index 1
        set -g renumber-windows on
        set-window-option -g pane-base-index 1
        set -ga terminal-overrides ",*:Tc"

        bind-key -r f run-shell "tmux neww tmux-find"

        # Select panes
        bind r source-file ~/.config/tmux/tmux.conf
        bind h select-pane -L
        bind l select-pane -R
        bind k select-pane -U
        bind j select-pane -D

        # Resize panes
        bind -n M-h resize-pane -L 2
        bind -n M-l resize-pane -R 2
        bind -n M-k resize-pane -U 2
        bind -n M-j resize-pane -D 2
        bind -n M-Left resize-pane -L 2
        bind -n M-Right resize-pane -R 2
        bind -n M-Up resize-pane -U 2
        bind -n M-Down resize-pane -D 2

        # Splits
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # Select windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # vi mode
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
  };
}
