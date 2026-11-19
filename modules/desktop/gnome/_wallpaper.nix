{ inputs, pkgs, ... }:

{
  _gnome = {
    extensions = [ inputs.hyperbolic.packages.${pkgs.stdenv.hostPlatform.system}.static-workspace-background ];
    dconf.user."org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file://${inputs.hyperbolic.packages.${pkgs.stdenv.hostPlatform.system}.macbook-pro-late-black}";
      picture-uri-dark = "file://${inputs.hyperbolic.packages.${pkgs.stdenv.hostPlatform.system}.macbook-pro-late-black}";
    };
  };
}
