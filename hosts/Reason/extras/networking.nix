_:

let
  dns = [
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
    "2620:fe::fe#dns.quad9.net"
    "2620:fe::9#dns.quad9.net"
  ];
in {
  networking = {
    nftables.enable = true;
    networkmanager.enable = false;
    useDHCP = false;
    dhcpcd.enable = false;
    useNetworkd = true;
    nameservers = dns;
    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" "fd71:3362:beef:1::1/64" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/private.key";
      peers = [
        {
          publicKey = "8PrXmK62578I5QfpfTRn27n6m6KNRkM2nWobmN/1aFg=";
          presharedKeyFile = "/etc/wireguard/psk.key";
          allowedIPs = [ "10.100.0.2/32" "fd71:3362:beef:1::2/128" ];
        }
      ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
      interfaces."wg0".allowedTCPPorts = [ 22 ];
    };
  };

  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.Name = "en* eth*";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        IPv6PrivacyExtensions = "no";
      };

      ipv6AcceptRAConfig = {
        Token = "prefixstable";
        UseDNS = false;
      };

      dhcpV4Config.UseDNS = false;
      dhcpV6Config.UseDNS = false;
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      DNSOverTLS = "true";
      Domains = [ "~." ];
      FallbackDNS = dns;
    };
  };
}
