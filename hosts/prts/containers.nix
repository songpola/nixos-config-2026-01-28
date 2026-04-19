{ delib, ... }:
delib.host {
  name = "prts";

  # Enable virtualization infrastructure
  myconfig.virtualization.docker.enable = true;
  myconfig.virtualization.podman.enable = true;

  # Caddy as reverse proxy for web services
  myconfig.services.caddy-reverse-proxy.podman = {
    enable = true;
    configDir = "/tank/v1/caddy-reverse-proxy/config";
  };

  # Arcane for managing containers
  myconfig.containers.arcane.podman = {
    enable = true;
    siteAddress = "arcane.songpola.dev";
    projectsDir = "/tank/v1/arcane/projects";
    baseServerUrl = "https://songpola.dev";
  };

  # Dozzle for viewing container logs
  myconfig.containers.dozzle.podman = {
    enable = true;
    siteAddress = "dozzle.songpola.dev";
  };

  # ProtonMail Bridge for email integration with Thunderbird
  myconfig.containers.protonmail-bridge.podman = {
    enable = true;
    dataDir = "/tank/v1/protonmail-bridge/root";
    smtpPort = 1025;
    imapPort = 1143;
  };

  # Radicale for calendar and contact management
  myconfig.containers.radicale.podman = {
    # enable = true;
    siteAddress = "radicale.songpola.dev";
    configDir = "/tank/v1/radicale/config";
    dataDir = "/tank/v1/radicale/data";
  };

  # qui for managing qBittorrent instances
  myconfig.services.qui.podman = {
    enable = true;
    siteAddress = "qui.songpola.dev";
    configDir = "/tank/v1/podman/rootful/containers/qui/config";
  };

  myconfig.services.dokploy.enable = false;
}
