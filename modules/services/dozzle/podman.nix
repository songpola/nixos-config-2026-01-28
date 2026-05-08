{
  delib,
  config,
  addCaddyReverseProxyConfig,
  ...
}:
delib.module {
  name = "services.dozzle.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      siteAddress = allowNull (strOption null);
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      inherit (config.virtualisation.quadlet) volumes;
    in
    {
      virtualisation.quadlet = {
        containers."dozzle".containerConfig =
          {
            image = "docker.io/amir20/dozzle:latest";
            volumes = [
              "%t/podman/podman.sock:/var/run/docker.sock"
              "${volumes."dozzle-data".ref}:/data"
            ];
            environments = {
              TZ = "Asia/Bangkok";
              DOZZLE_ENABLE_ACTIONS = "true";
            };
          }
          |> addCaddyReverseProxyConfig {
            address = cfg.siteAddress;
            port = 8080;
          };
        volumes."dozzle-data" = { };
      };
    };
}
