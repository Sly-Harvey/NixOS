{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH (Secure Shell) - remote access
        80 # HTTP - web traffic
        443 # HTTPS - encrypted web traffic
        59010 # Custom application port
        59011 # Custom application port
        8080 # Alternative HTTP/web server port
      ];
      allowedUDPPorts = [
        59010 # Custom application port
        59011 # Custom application port
      ];
    };
    localCommands = ''
      WANIF="eno1"

      # Exit early if the specified network interface does not exist
      ${pkgs.iproute2}/bin/ip link show "$WANIF" > /dev/null 2>&1 || exit 0

      # Remove any existing qdiscs on WAN interface and ifb0 to avoid conflicts
      ${pkgs.iproute2}/bin/tc qdisc del dev "$WANIF" root || true
      ${pkgs.iproute2}/bin/tc qdisc del dev ifb0 root || true

      # Create the ifb0 interface if it does not exist (used for ingress traffic shaping)
      ${pkgs.iproute2}/bin/ip link show ifb0 > /dev/null 2>&1 || \
        ${pkgs.iproute2}/bin/ip link add name ifb0 type ifb
      ${pkgs.iproute2}/bin/ip link set dev ifb0 up

      # Apply Cake queuing discipline on the WAN interface for upload shaping
      # Options:
      # - bandwidth: set maximum upload bandwidth limit
      # - diffserv4: enable DiffServ for QoS marking support
      # - triple-isolate: isolate flows between local, ingress, and egress
      # - nat: improve NAT handling for better fairness
      # - wash: normalize DSCP markings
      # - ack-filter: filter TCP ACK packets to reduce unnecessary traffic
      # - overhead: account for protocol overhead in shaping calculations
      ${pkgs.iproute2}/bin/tc qdisc add dev "$WANIF" root cake \
        diffserv4 triple-isolate nat wash ack-filter overhead 50

      # Add ingress qdisc on WAN interface to redirect ingress traffic to ifb0
      ${pkgs.iproute2}/bin/tc qdisc add dev "$WANIF" handle ffff: ingress

      # Redirect all incoming IP traffic from WAN interface to ifb0 for download shaping
      ${pkgs.iproute2}/bin/tc filter add dev "$WANIF" parent ffff: protocol ip u32 match u32 0 0 \
        flowid 1:1 action mirred egress redirect dev ifb0

      # Apply Cake queuing discipline on ifb0 interface for download shaping
      # Same options as upload shaping, but without 'nat' as it's unnecessary here
      ${pkgs.iproute2}/bin/tc qdisc add dev ifb0 root cake \
        diffserv4 triple-isolate nat wash overhead 50
    '';
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iproute2
  ];
}
