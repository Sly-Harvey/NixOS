local wezterm = require 'wezterm'

local config = {}

-- Colors (Catppuccin Mocha)
config.colors = {
  foreground = '#cdd6f4',
  background = '#1e1e2e',

  cursor_bg = '#f5e0dc',
  cursor_fg = '#1e1e2e',
  cursor_border = '#f5e0dc',

  selection_fg = '#1e1e2e',
  selection_bg = '#f5e0dc',

  ansi = {
    '#45475a', -- black (Surface1)
    '#f38ba8', -- red
    '#a6e3a1', -- green
    '#f9e2af', -- yellow
    '#89b4fa', -- blue
    '#f5c2e7', -- pink
    '#94e2d5', -- teal
    '#bac2de', -- white (Subtext1)
  },

  brights = {
    '#585b70', -- black (Surface2)
    '#f38ba8', -- red
    '#a6e3a1', -- green
    '#f9e2af', -- yellow
    '#89b4fa', -- blue
    '#f5c2e7', -- pink
    '#94e2d5', -- teal
    '#a6adc8', -- white (Subtext0)
  },

  tab_bar = {
    active_tab = {
      bg_color = '#cba6f7',
      fg_color = '#1e1e2e',
    },

    inactive_tab = {
      bg_color = '#313244',
      fg_color = '#bac2de',
    },

    inactive_tab_hover = {
      bg_color = '#45475a',
      fg_color = '#cdd6f4',
    },

    new_tab = {
      bg_color = '#313244',
      fg_color = '#89b4fa',
    },

    new_tab_hover = {
      bg_color = '#45475a',
      fg_color = '#89b4fa',
    },
  },
}

-- Window
config.window_close_confirmation = 'NeverPrompt'
config.show_tab_index_in_tab_bar = true
config.show_close_tab_button_in_tabs = false
config.window_decorations = 'NONE'
config.default_cursor_style = 'SteadyBlock'
config.enable_scroll_bar = false
config.window_frame = {
  inactive_titlebar_bg = 'none',
  active_titlebar_bg = 'none',
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.initial_cols = 100
config.initial_rows = 30

-- Shell
config.default_prog = { 'zsh' }

-- Scrollback
config.scrollback_lines = 10000

-- Selection
config.selection_word_boundary = ' \t\n{}()[]\'\"`'

-- Disable update checks
config.check_for_updates = false

-- Keybindings
config.keys = {
  -- Ctrl+F: fzf directory navigation
  {
    key = 'F',
    mods = 'CTRL',
    action = wezterm.action.SendString(
      'cd $(fd . /mnt/work /mnt/work/dev/ /run /run/current-system ~/.local/ ~/ --max-depth 2 | fzf)\r'
    ),
  },
  -- Ctrl+T: tmux-sessionizer
  {
    key = 'T',
    mods = 'CTRL',
    action = wezterm.action.SendString 'tmux-sessionizer\r',
  },
  -- Ctrl+Y: Paste
  {
    key = 'Y',
    mods = 'CTRL',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  -- Alt+W: Copy
  {
    key = 'W',
    mods = 'ALT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  -- Super+Shift+Return: New window
  {
    key = 'Enter',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  title = wezterm.truncate_right(title, max_width - 2)

  if tab.is_active then
    return {
      { Background = { Color = '#cba6f7' } },
      { Foreground = { Color = '#1e1e2e' } },
      { Text = ' ' .. title .. ' ' },
    }
  end
  return ' ' .. title .. ' '
end)

return config
