{ pkgs, ... }:

pkgs.libvirt-glib.overrideAttrs (_: {
    pname = "libvirt-glib-nightly";
    version = "boxes-fork";

    src = pkgs.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "felipeborges";
      repo = "libvirt-glib";
      rev = "5ced8aba9740531f193fe6ebbe15769e5596a68c";
      hash = "sha256-Z4Wdzxz5tk+hLnFlg/xozJWtDEXTrAo8wtAq680Nnps=";
    };

    patches = [ ];
  })
