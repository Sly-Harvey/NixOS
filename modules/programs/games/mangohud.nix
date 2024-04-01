{
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settingsPerApplication = {
        mpv = {
          no_display = true;
        };
      };
      settings = {
        fps_limit = 120;

        # keybinds
        toggle_hud = "Shift_R+F12";
        # toggle_hud_position="Shift_R+F11";
        toggle_fps_limit = "Shift_L+F1";
        # toggle_logging="Shift_L+F2";
        # reload_cfg="Shift_L+F4";
        # upload_log="Shift_L+F3";

        # SYSTEM
        fps = true;
        show_fps_limit = true;
        frametime = true;
        frame_timing = true;
        core_load = true;
        ram = true;
        # swap
        # core_load_change

        # CPU
        cpu_stats = true;
        cpu_temp = true;
        cpu_power = true;
        cpu_text = "CPU";
        cpu_mhz = true;

        # GPU
        throttling_status = true;
        gpu_stats = true;
        gpu_temp = true;
        gpu_core_clock = true;
        gpu_mem_clock = true;
        gpu_power = true;
        gpu_text = "GPU";
        vram = true;
        # gpu_load_change
        # gpu_load_value=60,90
        # gpu_load_color=39F900,FDFD09,B22222
      };
    };
  };
}
