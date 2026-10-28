{ inputs, pkgs, ... }:

{
  _gnome = {
    extensions = [ inputs.aequor.packages.${pkgs.stdenv.hostPlatform.system}.static-workspace-background ];
    keybinds = [
      {
        name = "Switch Wallpaper";
        command = "switch-wallpaper";
        binding = "<Super>R";
      }
    ];
  };
}
