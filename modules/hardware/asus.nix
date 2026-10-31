{ pkgs, ... }:

{
  boot = {
    kernelParams = [ "i8042.nokbd" ];
    initrd.kernelModules = [ "amdgpu" ];
  };

  services = {
    supergfxd.enable = true;
    asusd.enable = true;
  };

  systemd.services.asusd.postStart = let
    aura = "${pkgs.asusctl}/bin/asusctl aura effect static";
  in ''
    (
      ${aura} --zone 1 --colour 00ff00
      ${aura} --zone 2 --colour 00ffff
      ${aura} --zone 3 --colour 0000ff
      ${aura} --zone 4 --colour ff00ff
    ) &
  '';
}
