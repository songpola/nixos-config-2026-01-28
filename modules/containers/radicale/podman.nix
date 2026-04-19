{
  delib,
  addCaddyReverseProxyConfig,
  ...
}:
delib.module {
  name = "containers.radicale.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      siteAddress = allowNull (strOption null);
      configDir = allowNull (strOption null);
      dataDir = allowNull (strOption null);
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      virtualisation.quadlet = {
        enable = true;
        containers."radicale".containerConfig =
          {
            image = "ghcr.io/kozea/radicale:latest";
            volumes = [
              "${cfg.configDir}:/etc/radicale:ro"
              "${cfg.dataDir}:/var/lib/radicale"
            ];
            environments = {
              TZ = "Asia/Bangkok";
            };
          }
          |> addCaddyReverseProxyConfig {
            address = cfg.siteAddress;
            port = 5232;
          };
      };
    };
}
