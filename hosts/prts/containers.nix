{ delib, ... }:
delib.host {
  name = "prts";

  # Enable virtualization infrastructure
  myconfig.virtualization.docker.enable = true;
  myconfig.virtualization.podman.enable = true;

  # Caddy as reverse proxy for web services
  myconfig.containers.caddy-reverse-proxy.podman = {
    enable = true;
    configDirectory = "/tank/v1/caddy-reverse-proxy/config";
  };

  # Arcane for managing containers
  myconfig.containers.arcane.podman = {
    enable = true;
    address = "arcane.songpola.dev";
    projectsDirectory = "/tank/v1/arcane/projects";
    baseServerUrl = "https://home.songpola.dev";
  };

  # Dozzle for viewing container logs
  myconfig.containers.dozzle.podman = {
    enable = true;
    address = "dozzle.songpola.dev";
  };

  myconfig.containers.protonmail-bridge.podman = {
    enable = true;
    dataDirectory = "/tank/v1/protonmail-bridge/root";
    smtpPort = 1025;
    imapPort = 1143;
  };

  # Radicale for calendar and contact management
  myconfig.containers.radicale.podman = {
    enable = true;
    address = "radicale.songpola.dev";
    configDirectory = "/tank/v1/radicale/config";
    dataDirectory = "/tank/v1/radicale/data";
  };

  myconfig.services.dokploy.enable = true;
}
