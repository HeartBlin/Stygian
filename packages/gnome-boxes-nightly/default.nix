{ pkgs, ... }:

let
  libmks-nightly = pkgs.callPackage ../libmks-nightly { };
  libvirt-glib-nightly = pkgs.callPackage ../libvirt-glib-nightly { };
in
  pkgs.stdenv.mkDerivation {
    pname = "gnome-boxes-nightly";
    version = "nightly";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "felipeborges";
      repo = "boxes";
      rev = "43a614c1032951327f70bd6d208dc8538b147c16";
      hash = "sha256-DEHELh0ff99qX0RY5+wulacb/ZIhRTtqOKVuGUGl0j8=";
    };

    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      vala
      blueprint-compiler
      wrapGAppsHook4
      desktop-file-utils
      appstream-glib
    ];

    buildInputs = with pkgs; [
      libadwaita
      libvirt-glib-nightly
      libvirt
      libosinfo
      spice-gtk
      spice-protocol
      libsoup_3
      libmks-nightly
      libxml2
      gtksourceview5
    ];

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.qemu_kvm ]}"
      )
    '';
  }
