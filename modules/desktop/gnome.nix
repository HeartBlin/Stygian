{ pkgs, ... }:

{
  imports = [
    # Some helpers
    ./gnome/_options.nix

    # Desktop
    ./gnome/_desktop.nix
    ./gnome/_appearance.nix
    ./gnome/_keybinds.nix
    ./gnome/_extensions.nix
    ./gnome/_theme.nix

    # Standalone "features"
    ./gnome/_nautilus.nix
    ./gnome/_vicinae.nix
    ./gnome/_wallpaper.nix
  ];

  # Get GNOME
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    decibels # Audio file player
    evince # Document viewer
    epiphany # Web browser
    gnome-console
    gnome-contacts
    gnome-maps
    gnome-text-editor
    gnome-tour # First time greeter thing
    geary # E-mail client
    snapshot # Camera
    totem # Movie player
    yelp # Help
  ];
}
