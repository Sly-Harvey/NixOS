{ host, pkgs, ... }:

let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  boot = {
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      # TCP hardening
      "kernel.sysrq" = 0;
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

      # BBR + ECN optimization (Kernel 6.x)
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_ecn" = 1;
      "net.ipv4.tcp_ecn_fallback" = 1;

      # TCP ultra low latency
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_fin_timeout" = 30;
      "net.ipv4.tcp_window_scaling" = 1;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_notsent_lowat" = 16384;

      # BBR pacing (Kernel 6.x)
      "net.ipv4.tcp_pacing_ss_ratio" = 200;
      "net.ipv4.tcp_pacing_ca_ratio" = 120;

      # Buffer optimization (1Gbps Optimized)
      "net.ipv4.tcp_rmem" = "4096 131072 67108864";
      "net.ipv4.tcp_wmem" = "4096 65536 67108864";
      "net.core.wmem_max" = 67108864;
      "net.core.rmem_max" = 67108864;
      "net.core.wmem_default" = 1048576;
      "net.core.rmem_default" = 1048576;

      # Queue management
      "net.core.default_qdisc" = "fq";
      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 2048;

      # Netdev budget
      "net.core.netdev_budget" = 600;
      "net.core.netdev_budget_usecs" = 8000;

      # Kernel Security Hardening
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.yama.ptrace_scope" = 1;

      # BPF JIT compiler (performance boost & hardening)
      "net.core.bpf_jit_enable" = 1;
      "net.core.bpf_jit_harden" = 2;
      "net.core.bpf_jit_kallsyms" = 1;

      # IPv6
      "net.ipv6.conf.all.accept_ra" = 1;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
