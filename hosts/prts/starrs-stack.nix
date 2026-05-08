{ delib, ... }:
delib.host {
  name = "prts";

  # Enable virtualization infrastructure
  myconfig.virtualization.podman.enable = true;

  # Starrs stack for media automation
  myconfig.stacks.starrs.podman = {
    enable = true;
    baseSiteAddress = "songpola.dev";
    baseConfigDir = "/tank/v2/starrs-stack";
    baseDataDir = "/tank/v2/starrs-data";
    torrentingPort = 6882;
  };

  # Jellyfin for media streaming
  myconfig.services.jellyfin.podman = {
    enable = true;
    siteAddress = "jf.songpola.dev";
    configDir = "/tank/v2/services/jellyfin/config";
    mediaDataDir = "/tank/v2/starrs-data/media";
  };
}
