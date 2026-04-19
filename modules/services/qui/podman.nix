{
  delib,
  addCaddyReverseProxyConfig,
  config,
  ...
}:
let
  inherit (config.virtualisation.quadlet) networks;

  quiNetwork = "qui";
in
delib.module {
  name = "services.qui.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      siteAddress = allowNull (strOption null);
      configDir = strOption null;
      networkRef = readOnly (strOption (networks.${quiNetwork}.ref));

      # This option should be used by other modules to add extra volumes to the qui container,
      # for example, to enable integration with other qBittorrent instances.
      # https://getqui.com/docs/getting-started/docker#local-filesystem-access
      extraVolumes = listOfOption str [ ];
    };

  myconfig.always =
    { cfg, ... }:
    {
      args.shared = {
        quiNetworkRef = cfg.networkRef;
      };
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      virtualisation.quadlet = {
        enable = true;
        networks.${quiNetwork} = { };
        containers."qui".containerConfig =
          {
            # https://hotio.dev/containers/qui/
            image = "ghcr.io/hotio/qui:latest";
            environments = {
              TZ = "Asia/Bangkok";
              PUID = "1000";
              PGID = "1000";
            };
            volumes = [
              "${cfg.configDir}:/config"
            ]
            ++ cfg.extraVolumes;
            networks = [ cfg.networkRef ];
          }
          |> addCaddyReverseProxyConfig {
            address = cfg.siteAddress;
            port = 7476;
          };
      };
    };
}
