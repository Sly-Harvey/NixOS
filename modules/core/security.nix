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
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_low_latency" = "1";
      "net.ipv4.tcp_fin_timeout" = "10";
      # "net.ipv4.tcp_max_tw_buckets" = "450000"; # https://sysctl-explorer.net/net/ipv4/tcp_max_tw_buckets/
      "net.ipv4.tcp_window_scaling" = "1";
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 87380 16777216";
      #https://nixsanctuary.com/linux-network-performance-optimization-tips-for-optimizing-linux-network-throughput-and-latency/
      "net.core.default_qdisc" = "cake"; # Important for bufferbloat
      "net.core.wmem_max" = 67108864;
      "net.core.rmem_max" = 67108864;
      "net.core.netdev_max_backlog" = "10000";
    };
  };
}
