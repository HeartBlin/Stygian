{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "libmks";
  version = "main";

  src = pkgs.fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libmks";
    rev = "103803fc2b581d68cf16918cee9a2fa18b47adcc";
    hash = "sha256-qV+HX7CSx6vcWnbisiDWbBDyCR7qC8wX/j+twVrZQn0=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  propagatedBuildInputs = with pkgs; [
    vte-gtk4
    libdex
    libsysprof-capture
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];
}
