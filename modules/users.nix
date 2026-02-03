{
  lib,
  homeManagerUser,
  config,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
in
mkMerge [
  # WSL: set default user (will be created if not exists)
  (mkIf (config.wsl.enable) { wsl.defaultUser = homeManagerUser; })
  {
    users.users.${homeManagerUser} = {
      isNormalUser = true;
      uid = 1000;
      # Default to private group instead of shared "users" group
      group = homeManagerUser;
      extraGroups = [
        "users"
        "wheel"
      ];
    };

    users.groups.${homeManagerUser}.gid = 1000;
  }
]
