{ config, inputs, ... }:

{
  imports = [ inputs.hjem.nixosModules.hjem ];

  services.userborn.enable = true;
  users.users.primaryUser = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  hjem = {
    clobberByDefault = true;
    users.primaryUser = {
      enable = true;
      user = config.users.users.primaryUser.name;
      directory = config.users.users.primaryUser.home;
    };
  };
}
