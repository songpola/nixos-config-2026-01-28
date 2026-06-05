{
  delib,
  addCaddyReverseProxyConfig,
  ...
}:
delib.module {
  name = "services.dockge.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      siteAddress = allowNull (strOption null);
      dataDir = allowNull (strOption null);
      stacksDir = allowNull (strOption null);
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      virtualisation.quadlet = {
        containers."dockge".containerConfig =
          {
            image = "docker.io/louislam/dockge:1";
            volumes = [
              "%t/podman/podman.sock:/var/run/docker.sock"
              "${cfg.dataDir}:/app/data"
              "${cfg.stacksDir}:${cfg.stacksDir}"
            ];
            environments = {
              TZ = "Asia/Bangkok";
              PUID = "1000";
              PGID = "1000";
              DOCKGE_STACKS_DIR = cfg.stacksDir;
            };
          }
          |> addCaddyReverseProxyConfig {
            address = cfg.siteAddress;
            port = 5001;
          };
      };
    };
}
