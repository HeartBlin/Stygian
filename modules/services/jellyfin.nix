let
  inherit (import ./_caddy.nix) domain mTLS;
in {
  users.users.jellyfin.extraGroups = [ "render" "video" ];
  services = {
    jellyfin = {
      enable = true;
      hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/renderD128";
      };

      # For a Ryzen 5 4600G
      forceEncodingConfig = true;
      transcoding = {
        enableHardwareEncoding = true;
        hardwareEncodingCodecs = {
          hevc = true;
          av1 = false;
        };

        hardwareDecodingCodecs = {
          h264 = true;
          hevc = true;
          hevc10bit = true;
          mpeg2 = true;
          vc1 = true;
          vp9 = true;
          vp8 = false;
          av1 = false;
        };
      };
    };

    caddy.virtualHosts."media.${domain}".extraConfig =
      mTLS
      "reverse_proxy http://[::1]:8096";
  };

  systemd.services.jellyfin.serviceConfig = {
    SupplementaryGroups = [ "music" ];
    ReadOnlyPaths = [ "/data/music" ];
  };
}
