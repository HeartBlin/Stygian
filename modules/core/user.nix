{ config, inputs, ... }:

{
  imports = [ inputs.hjem.nixosModules.default ];
  services.userborn.enable = true;
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

  # For some fucking reason hjem doesnt want lists in `value`
  # even though for builtins.JSON it is valid. ffs
}
