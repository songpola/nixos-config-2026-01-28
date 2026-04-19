{
  delib,
  addCaddyReverseProxyConfig,
  ...
}:
delib.module {
  name = "containers.jellyfin.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      siteAddress = allowNull (strOption null);
      configDir = strOption null;
      mediaDataDir = strOption null;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      virtualisation.quadlet =
        let
          # Internal to containers, rarely change.
          # This will be the same across all Starrs containers,
          # to enable the "Atomic Move" technique (hardlinking instead of copying files).
          containerBaseDataDir = "/mnt/starrs-data";
          containerMediaDataDir = "${containerBaseDataDir}/media";
        in
        {
          enable = true;
          containers."jellyfin".containerConfig =
            {
              image = "lscr.io/linuxserver/jellyfin:version-10.11.2ubu2404";
              environments = {
                TZ = "Asia/Bangkok";
                PUID = "1000";
                PGID = "1000";
                #? JELLYFIN_PublishedServerUrl
              };
              volumes = [
                "${cfg.configDir}:/config"
                "${cfg.mediaDataDir}:${containerMediaDataDir}"
              ];
              devices = [
                "nvidia.com/gpu=all"
              ];
            }
            |> addCaddyReverseProxyConfig {
              address = cfg.siteAddress;
              port = 8096;
            };
        };
    };
}
