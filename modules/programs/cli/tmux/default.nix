{
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
  home-manager.sharedModules = [
    (_: {
      programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
        # terminal = "tmux-256color";
        terminal = "screen-256color";
        historyLimit = 100000;
        plugins = with pkgs.tmuxPlugins; [
          dreamsofcode-io-catppuccin-tmux
          # catppuccin
          sensible
          vim-tmux-navigator
          /*
             {
            plugin = resurrect;
            extraConfig =
              ''
                set -g @resurrect-strategy-vim 'session'
                set -g @resurrect-strategy-nvim 'session'
                set -g @resurrect-capture-pane-contents 'on'
              ''
              + ''
                # Taken from https://github.com/hmajid2301/dotfiles/blob/main/modules/home/cli/multiplexers/tmux/default.nix#L109
                # Which was taken from: https://github.com/p3t33/nixos_flake/blob/5a989e5af403b4efe296be6f39ffe6d5d440d6d6/home/modules/tmux.nix

                resurrect_dir="$XDG_CACHE_HOME/tmux/resurrect"
                set -g @resurrect-dir $resurrect_dir
                set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | ${moreutils}/bin/sponge $target'
              '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-boot 'on'
              set -g @continuum-save-interval '10'
              set -g @continuum-systemd-start-cmd 'start-server'
            '';
          }
          */
        ];
        extraConfig = ''
          unbind C-b
          set -g prefix C-a
          bind C-a send-prefix

          # Options
          set -g @catppuccin_flavour 'macchiato'
          set -g mouse on
          set -g allow-rename off
          set -g status-position top
          set -g base-index 1
          set -g pane-base-index 1
          set -g renumber-windows on
          set-window-option -g pane-base-index 1
          set -ga terminal-overrides ",*:Tc"

          # Tmux sessionizer
          bind-key -r f run-shell "tmux neww tmux-sessionizer"

          # Tmux binds
          bind r command-prompt "rename-window %%"
          bind R source-file ~/.config/tmux/tmux.conf
          bind w list-windows
          bind * setw synchronize-panes
          bind P set pane-border-status
          bind -n C-M-c kill-pane
          bind x swap-pane -D
          bind z resize-pane -Z

          # Select panes
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
    })
  ];
}
