{ inputs, lib, pkgs, ... }:

let
  ovmfEnroll =
    (pkgs.OVMF.override {
      secureBoot = true;
      msVarsTemplate = true;
    }).fd;

  qemuWithEnrolledOVMF = pkgs.qemu_kvm.overrideAttrs (x: {
    postInstall =
      (x.postInstall or "")
      + ''
        mkdir -p "$out/share/qemu/firmware"

        install -Dm644 \
          ${ovmfEnroll}/FV/OVMF_CODE.fd \
          "$out/share/qemu/OVMF_CODE.fd"

        install -Dm644 \
          ${ovmfEnroll}/FV/OVMF_VARS.ms.fd \
          "$out/share/qemu/OVMF_VARS.ms.fd"

        sed "s|${ovmfEnroll}/FV/|$out/share/qemu/|g" \
          ${ovmfEnroll}/share/qemu/firmware/40-edk2-x86_64-sb-enrolled.json \
          > "$out/share/qemu/firmware/40-edk2-x86_64-sb-enrolled.json"
      '';
  });
in {
  users.users.primaryUser.extraGroups = [ "libvirtd" ];
  environment.systemPackages = [
    inputs.hyperbolic.packages.${pkgs.stdenv.hostPlatform.system}.gnome-boxes-nightly
    pkgs.passt
    pkgs.swtpm
  ];

  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    qemu = {
      package = qemuWithEnrolledOVMF;
      swtpm.enable = true;
    };
  };
}
