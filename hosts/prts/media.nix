{ delib, ... }:
delib.host {
  name = "prts";

  # Enable virtualization infrastructure
  myconfig.virtualization.podman.enable = true;

  # Starrs stack for media automation
  myconfig.stacks.starrs.podman = {
    enable = true;
    baseSiteAddress = "songpola.dev";
    baseConfigDir = "/tank/v1/podman/rootful/stacks/starrs";
    baseDataDir = "/tank/v1/starrs-data";
    torrentingPort = 6882;
  };

  # Jellyfin for media streaming
  myconfig.containers.jellyfin.podman = {
    enable = true;
    siteAddress = "jf.songpola.dev";
    configDir = "/tank/v1/podman/rootful/containers/jellyfin/config";
    mediaDataDir = "/tank/v1/starrs-data/media";
  };
}
