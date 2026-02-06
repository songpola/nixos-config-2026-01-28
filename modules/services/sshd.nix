{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "services.sshd";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.isServer;

      userAuthorizedKeys = attrsOfOption (listOf str) { };
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.openssh.enable = true;

      users.users = lib.mkIf (cfg.userAuthorizedKeys != { }) (
        cfg.userAuthorizedKeys
        |> builtins.mapAttrs (
          username: keys: {
            openssh.authorizedKeys = { inherit keys; };
          }
        )
      );
    };
}
