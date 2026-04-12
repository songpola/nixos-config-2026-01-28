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

      configDirectory = allowNull (strOption null);
      dataDirectory = allowNull (strOption null);
      address = allowNull (strOption null);
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
              "${cfg.configDirectory}:/etc/radicale:ro"
              "${cfg.dataDirectory}:/var/lib/radicale"
            ];
            environments = {
              TZ = "Asia/Bangkok";
            };
          }
          |> addCaddyReverseProxyConfig {
            address = cfg.address;
            port = 5232;
          };
      };
    };
}
