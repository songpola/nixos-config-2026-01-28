{ delib, ... }:
delib.host {
  name = "prts";

  # Enable virtualization infrastructure
  myconfig.virtualization.docker.enable = false;
  myconfig.virtualization.podman.enable = true;

  # Caddy as reverse proxy for web services
  myconfig.services.caddy-reverse-proxy.podman = {
    enable = true;
    configDir = "/tank/v2/services/caddy-reverse-proxy/config";
  };

  # Dozzle for viewing container logs
  myconfig.services.dozzle.podman = {
    enable = true;
    siteAddress = "dozzle.songpola.dev";
  };

  # Arcane for managing containers
  myconfig.services.arcane.podman = {
    enable = true;
    siteAddress = "arcane.songpola.dev";
    projectsDir = "/tank/v2/services/arcane/projects";
    baseServerUrl = "https://songpola.dev";
  };

  # qui for managing qBittorrent instances
  myconfig.services.qui.podman = {
    enable = true;
    siteAddress = "qui.songpola.dev";
    configDir = "/tank/v2/services/qui/config";
  };

  # ProtonMail Bridge for email integration with Thunderbird
  myconfig.services.protonmail-bridge.podman = {
    enable = true;
    dataDir = "/tank/v2/services/protonmail-bridge/root";
    smtpPort = 1025;
    imapPort = 1143;
  };

  # Radicale for calendar and contact management
  myconfig.services.radicale.podman = {
    enable = false;
    siteAddress = "radicale.songpola.dev";
    configDir = "/tank/v1/radicale/config";
    dataDir = "/tank/v1/radicale/data";
  };

  myconfig.services.dokploy.enable = false;
}
