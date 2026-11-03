{
  services.userborn.enable = true;
  users.users.primaryUser = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
