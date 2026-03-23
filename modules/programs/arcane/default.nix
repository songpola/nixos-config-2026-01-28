{
  delib,
  config,
  lib,
  addCaddyReverseProxyConfig,
  ...
}:
delib.module {
  name = "programs.arcane";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      address = allowNull (strOption null);
      projectsDirectory = allowNull (strOption null);
      puid = strOption "1000";
      pgid = strOption "1000";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      inherit (config.virtualisation.quadlet) volumes;
      inherit (config.sops) secrets;

      secret = "arcane/secrets.env";
    in
    {
      sops.secrets.${secret} = {
        sopsFile = ./secrets.env;
        format = "dotenv";
      };

      virtualisation.quadlet = {
        enable = true;

        containers."arcane".containerConfig =
          {
            image = "ghcr.io/getarcaneapp/arcane:latest";
            # publishPorts = [ "3552:3552" ];
            volumes = [
              # "/var/run/docker.sock:/var/run/docker.sock"
              "%t/podman/podman.sock:/var/run/docker.sock"
              "${volumes."arcane-data".ref}:/app/data"
            ]
            ++ lib.optional (cfg.projectsDirectory != null) "${cfg.projectsDirectory}:${cfg.projectsDirectory}";
            environmentFiles = [
              secrets.${secret}.path
            ];
            environments = {
              TZ = "Asia/Bangkok";
              PUID = cfg.puid;
              PGID = cfg.pgid;
              APP_URL = lib.mkIf (cfg.address != null) "https://${cfg.address}";
              PROJECTS_DIRECTORY = lib.mkIf (cfg.projectsDirectory != null) cfg.projectsDirectory;
              #! ENCRYPTION_KEY
              #! JWT_SECRET
            };
          }
          |> addCaddyReverseProxyConfig {
            address = cfg.address;
            port = 3552;
          };

        volumes."arcane-data" = { };
      };
    };
}
