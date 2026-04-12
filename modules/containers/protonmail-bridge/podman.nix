{
  delib,
  lib,
  ...
}:
delib.module {
  name = "containers.protonmail-bridge.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      dataDirectory = allowNull (strOption null);
      smtpPort = allowNull (portOption null);
      imapPort = allowNull (portOption null);
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      virtualisation.quadlet = {
        enable = true;
        containers."protonmail-bridge".containerConfig = {
          # https://github.com/shenxn/protonmail-bridge-docker/issues/135
          image = "docker.io/dancwilliams/protonmail-bridge:latest";
          volumes = [
            "${cfg.dataDirectory}:/root"
          ];
          environments = {
            TZ = "Asia/Bangkok";
          };
          publishPorts =
            {
              "25" = cfg.smtpPort;
              "143" = cfg.imapPort;
            }
            |> lib.filterAttrs (_: hostPort: hostPort != null)
            |> lib.mapAttrsToList (containerPort: hostPort: "${toString hostPort}:${containerPort}");
        };
      };
    };
}
