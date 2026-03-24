{
  delib,
  host,
  lib,
  homeManagerUser,
  pkgs,
  ...
}:
delib.module {
  name = "virtualization.podman";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    virtualisation.podman.enable = true;
    users.users.${homeManagerUser} = {
      extraGroups = [ "podman" ];
      # Enable lingering for auto-starting containers before user login
      # and prevent containers termination on shell logout.
      # NOTE: Lingering does not work well on WSL.
      linger = lib.mkIf (!host.isWsl) true;
    };

    # Use original implementation for `podman compose` commands
    environment.systemPackages = [ pkgs.docker-compose ];
  };
}
