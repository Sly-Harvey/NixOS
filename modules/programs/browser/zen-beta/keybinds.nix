# Declarative keyboard shortcut overrides with version protection
# Version protection detects breaking changes after Zen updates.
# ⚠ Only if modifying keyboardShortcuts: close Zen before home-manager switch
# (activation script modifies zen-keyboard-shortcuts.json, which is locked while browser runs)
# Version check prevents silent breakage if Zen updates change the shortcuts schema.
[
  {
    id = "zen-toggle-sidebar";
    key = "s";
    modifiers = {
      alt = true;
    };
  }
]
# Find shortcut IDs in ~/.config/zen/default/zen-keyboard-shortcuts.json
# Get version from about:config -> zen.keyboard.shortcuts.version
# Activation fails if version changes (prevents silent breakage).
#
# Use this command:
# jq -c '.shortcuts[] | {id, key, keycode, action}' ~/.config/zen/default/zen-keyboard-shortcuts.json | fzf
