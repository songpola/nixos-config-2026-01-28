{
  delib,
  host,
  lib,
  homeManagerUser,
  ...
}:
delib.module {
  name = "virtualization.docker";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    virtualisation.docker.enable = true;
    users.users.${homeManagerUser} = {
      extraGroups = [ "docker" ];
      # Enable lingering for auto-starting containers before user login
      # and prevent containers termination on shell logout.
      # NOTE: Lingering does not work well on WSL.
      linger = lib.mkIf (!host.isWsl) true;
    };
  };
}
