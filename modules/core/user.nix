{ config, inputs, ... }:

{
  imports = [ inputs.hjem.nixosModules.default ];

  users.users.primaryUser = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  hjem.users.primaryUser = {
    enable = true;
    clobberFiles = true;
    user = config.users.users.primaryUser.name;
    directory = config.users.users.primaryUser.home;
  };
}
