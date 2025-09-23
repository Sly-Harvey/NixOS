{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  boot.kernelParams = [
    "intel_pstate=active"
    "i915.enable_guc=2" # Enable GuC/HuC firmware loading
    "i915.enable_psr=1" # Panel Self Refresh for power savings
    "i915.enable_fbc=1" # Framebuffer compression
    "i915.fastboot=1" # Skip unnecessary mode sets at boot
    "mem_sleep_default=deep" # Allow deepest sleep states
    "i915.enable_dc=2" # Display power saving
    "nvme.noacpi=1" # Helps with NVME power consumption
  ];

  # Load the driver
  services = {
    xserver.videoDrivers = [ "modesetting" ];

    # Thermal and Noise Management
    thermald.enable = true;
    throttled.enable = true;
  };

  # OpenGL
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
