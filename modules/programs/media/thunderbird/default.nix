{...}: {
  programs.thunderbird = {
    enable = true;
    policies = {
    };
    preferences = {
      "privacy.donottrackheader.enabled" = true;
    };
  };
}
