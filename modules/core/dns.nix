{ ... }:
{
  networking.firewall = {
    allowedTCPPorts = [
      53
      5335
    ];
    allowedUDPPorts = [
      53
      5335
    ];
  };
  # Disable systemd dns resolver
  services.resolved = {
    enable = false;
    domains = [ "~." ];
    fallbackDns = [ ]; # Empty to prevent bypass
    dnsovertls = "true";

    # github.com/systemd/systemd/issues/10579
    # dnssec = "allow-downgrade";
    dnssec = "false";
  };
  systemd.services = {
    unbound.stopIfChanged = false;
    adguardhome.serviceConfig = {
      After = [
        "network.target"
        "unbound.service"
      ];
      Requires = [ "unbound.service" ];
    };
  };
  services = {
    unbound = {
      enable = true;
      settings = {
        remote-control.control-enable = true;
        server = {
          # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
          # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
          interface = [ "127.0.0.1" ]; # "::1"
          port = 5335;
          access-control = [
            "127.0.0.1 allow"
            "192.168.1.0/24 allow"
          ];
          # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;
          hide-identity = true;
          hide-version = true;
        };
        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = "yes";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"

              # "9.9.9.9#dns.quad9.net"
              # "149.112.112.112#dns.quad9.net"
            ];
          }
        ];
      };
    };
    adguardhome = {
      enable = true;
      host = "0.0.0.0";
      port = 3005;
      mutableSettings = true;
      openFirewall = true;
      settings = {
        http = {
          address = "127.0.0.1:3005";
        };
        dns = {
          bind_host = "0.0.0.0";
          bind_port = 53;
          upstream_dns = [ "127.0.0.1:5335" ];
          bootstrap_dns = [ "127.0.0.1:5335" ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;

          parental_enabled = false;
          safe_search.enabled = false;
        };
        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
              "https://easylist.to/easylist/easylist.txt" # Base filter
              "https://easylist.to/easylist/easyprivacy.txt" # Privacy protection
              "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt" # Malware domains
              "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt" # Scam protection                                                                                      "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"  # Cryptominers

              # My Lists
              # "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt" # Large
              "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
              "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/annoyance_list.txt"
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/refs/heads/main/adblock/spam-tlds-ublock.txt"
              "https://raw.githubusercontent.com/iam-py-test/my_filters_001/refs/heads/main/antitypo.txt"
              # "https://raw.githubusercontent.com/iam-py-test/my_filters_001/refs/heads/main/antimalware.txt"
              # "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/Dandelion%20Sprout's%20Anti-Malware%20List.txt"
            ];
      };
    };
  };
  /*
    services.stubby = {
      enable = true;
      settings = {
        # ::1 cause error, use 0::1 instead
        listen_addresses = [
          "127.0.0.1@5300"
          "0::1@5300"
        ];
        resolution_type = "GETDNS_RESOLUTION_STUB";
        dns_transport_list = [ "GETDNS_TRANSPORT_TLS" ];
        tls_authentication = "GETDNS_AUTHENTICATION_REQUIRED";
        tls_query_padding_blocksize = 128;
        idle_timeout = 10000;
        round_robin_upstreams = 1;
        tls_min_version = "GETDNS_TLS1_3";
        dnssec = "GETDNS_EXTENSION_TRUE";
        upstream_recursive_servers = [
          {
            address_data = "1.0.0.2";
            tls_auth_name = "cloudflare-dns.com";
          }
          {
            address_data = "9.9.9.9";
            tls_auth_name = "dns.quad9.net";
          }
        ];
      };
    };
  */
}
