{pkgs, ...}: {
  boot.kernelParams = [
    "intel_pstate=active"
    "i915.enable_guc=2"
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
    "mem_sleep_default=deep"
    "i915.enable_dc=2"
    "nvme.noacpi=1"
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
}
