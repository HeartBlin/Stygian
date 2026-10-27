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
    dhcpcd.wait = "background";
    nameservers = dns;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      ensureProfiles = {
        environmentFiles = [ "/var/wireguard/nm.env" ];
        profiles.wg0 = {
          connection = {
            id = "Reason";
            type = "wireguard";
            interface-name = "wg0";
            autoconnect = false;
          };

          wireguard.private-key = "$WG_PRIVATE_KEY";
          "wireguard-peer.gSlbzoZW6NU4Ld+uVBlPP6FMVSYZUEqMR+h1fDpH1ig=" = {
            endpoint = "heartblin.eu:51820";
            allowed-ips = "10.100.0.0/24;fd71:3362:beef:1::/64;";
            persistent-keepalive = "25";
            preshared-key = "$WG_PSK";
            preshared-key-flags = "0";
          };

          ipv4 = {
            method = "manual";
            address1 = "10.100.0.2/24";
            never-default = "true";
          };

          ipv6 = {
            method = "manual";
            address1 = "fd71:3362:beef:1::2/64";
            never-default = "true";
          };
        };
      };
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
