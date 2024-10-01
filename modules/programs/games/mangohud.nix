{
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      /*
         xdg.configFile."MangoHud/MangoHud.conf".text = ''
        core_load
        cpu_mhz
        cpu_power
        cpu_stats
        cpu_temp
        cpu_text=CPU
        fps
        fps_limit=120
        frame_timing
        frametime
        gpu_core_clock
        gpu_mem_clock
        gpu_power
        gpu_stats
        gpu_temp
        gpu_text=GPU
        ram
        show_fps_limit
        throttling_status
        toggle_fps_limit=Shift_L+F1
        toggle_hud=Shift_R+F12
        vram
      '';
      */

      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
        settingsPerApplication = {
          mpv = {
            no_display = true;
          };
        };
        settings = {
          no_display = true; # Hide hud by default (Show by holding right-shift then press F12)
          fps_limit = 64;

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
          core_load = false;
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
    })
  ];
}
