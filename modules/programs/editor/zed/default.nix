{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ nil nixd ];
      programs.zed-editor = {
        enable = true;
        # mutableUserSettings = true;
        # mutableUserKeymaps = true;
        # mutableUserTasks = true;
        extensions = [
          "nix"
          "catppuccin"
          "catppuccin-icons"
        ];
        themes = {
        };
        userKeymaps = [
          { bindings.ctrl-alt-v = "workspace::ToggleVimMode"; }
        ];
        userSettings = {
          theme = {
            mode = "system";
            light = "Catppuccin Latte - No Italics";
            dark = "Catppuccin Macchiato - No Italics";
          };
          icon_theme = {
            mode = "system";
            light = "Catppuccin Latte";
            dark = "Catppuccin Macchiato";
          };
          base_keymap = "Zed";
          minimap.show = "auto";
          relative_line_numbers = "disabled";
          vim.toggle_relative_line_numbers = true;
          which_key = {
            enabled = true;
            delay_ms = 0;
          };
          toolbar = {
            breadcrumbs = false;
            code_actions = true;
          };
          project_panel = {
            hide_gitignore= false;
            dock= "right";
          };
          tabs.git_status = true;
          tab_bar.show = true;
          title_bar = {
            show_branch_status_icon = true;
            # show_onboarding_banner = false;
          };
          status_bar.show_active_file = true;
          telemetry = {
            diagnostics = false;
            metrics = false;
            anthropic_retention = false;
          };
          edit_predictions.allow_data_collection = "no";
          session.trust_all_worktrees = true;
          prettier.allowed = true;
          languages = {
            Nix.format_on_save = "modifications_if_available";
          };
          git_panel = {
            show_count_badge= true;
            status_style= "label_color";
            collapse_untracked_diff= false;
            file_icons= false;
            tree_view= true;
          };
          agent_servers.github-copilot-cli.type = "registry";
        };
      };
    })
  ];
}
