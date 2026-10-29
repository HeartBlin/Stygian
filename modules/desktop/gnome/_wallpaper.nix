{ pkgs, self, ... }:

{
  _gnome = {
    extensions = [ self.packages.${pkgs.stdenv.hostPlatform.system}.static-workspace-background ];
    dconf.user."org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file://${self.packages.${pkgs.stdenv.hostPlatform.system}.macbook-pro-late-black}";
      picture-uri-dark = "file://${self.packages.${pkgs.stdenv.hostPlatform.system}.macbook-pro-late-black}";
    };
  };
}
