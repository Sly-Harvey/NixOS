{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };

    # Prevent replacing the running kernel without a reboot
    protectKernelImage = true;
    acme.acceptTerms = true;
  };
  boot = {
    kernel.sysctl = {
      # TCP hardening
      "kernel.sysrq" = 0; # allows performing low-level commands.
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;

      # TCP optimization
      "net.ipv4.tcp_fastopen" = 0; # 3
    };
  };
}
