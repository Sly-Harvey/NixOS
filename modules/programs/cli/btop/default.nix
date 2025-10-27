{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.btop = {
        enable = true;
        package = pkgs.btop.override {
          rocmSupport = true;
          cudaSupport = true;
        };
        settings = {
          show_gpu_info = "on";
          cpu_sensor = "auto";
          vim_keys = true;
          rounded_corners = true;
          proc_tree = false;
          show_uptime = true;
          show_coretemp = true;
          show_disks = true;
          only_physical = true;
          io_mode = true;
          io_graph_combined = false;
        };
      };
    })
  ];
}
