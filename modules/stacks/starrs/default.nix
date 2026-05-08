{
  delib,
  lib,
  config,
  caddyReverseProxyIngressNetworkRef,
  quiNetworkRef,
  ...
}:
delib.module {
  name = "stacks.starrs.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      baseSiteAddress = allowNull (strOption null);
      baseConfigDir = strOption null;
      baseDataDir = strOption null;
      torrentingPort = allowNull (portOption null) |> lib.flip apply toString;

      qbittorrentImage = strOption "lscr.io/linuxserver/qbittorrent:version-5.1.4-r3";
      clonarrImage = strOption "ghcr.io/prophetse7en/clonarr:latest";
      prowlarrImage = strOption "lscr.io/linuxserver/prowlarr:version-2.3.5.5327";
      byparrImage = strOption "ghcr.io/thephaseless/byparr:latest";
      radarrImage = strOption "lscr.io/linuxserver/radarr:version-6.1.1.10360";
      sonarrImage = strOption "lscr.io/linuxserver/sonarr:version-4.0.17.2952";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      inherit (config.virtualisation.quadlet) pods;

      podName = "starrs";
      podRef = pods.${podName}.ref;

      qbittorrentName = "${podName}-qbittorrent";
      clonarrName = "${podName}-clonarr";
      byparrName = "${podName}-byparr";
      prowlarrName = "${podName}-prowlarr";
      radarrName = "${podName}-radarr";
      radarrAnimeName = "${radarrName}-anime";
      sonarrName = "${podName}-sonarr";
      sonarrAnimeName = "${sonarrName}-anime";

      # Internal to containers, rarely change.
      # This will be the same across all Starrs containers,
      # to enable the "Atomic Move" technique (hardlinking instead of copying files).
      containerBaseDataDir = "/mnt/starrs-data";
      containerTorrentsDataDir = "${containerBaseDataDir}/torrents";

      dataVolumeMount = "${cfg.baseDataDir}:${containerBaseDataDir}";
      torrentsDataVolumeMount = "${cfg.baseDataDir}/torrents:${containerTorrentsDataDir}";

      commmonEnvs = {
        TZ = "Asia/Bangkok";
        PUID = "1000";
        PGID = "1000";
      };
    in
    {
      # For starrs-qbittorrent <-> qui integration
      myconfig.services.qui.podman.extraVolumes = [ torrentsDataVolumeMount ];

      virtualisation.quadlet = {
        pods.${podName}.podConfig = {
          publishPorts =
            {
              # starrs-qbittorrent
              "${cfg.torrentingPort}" = cfg.torrentingPort;
              "${cfg.torrentingPort}/udp" = cfg.torrentingPort;
            }
            |> lib.filterAttrs (_: hostPort: hostPort != null)
            |> lib.mapAttrsToList (containerPort: hostPort: "${hostPort}:${containerPort}");
          networks = [
            caddyReverseProxyIngressNetworkRef
            "${quiNetworkRef}:alias=${podName}" # for qui integration
          ];
          labels =
            let
              mkCaddyLabels =
                services:
                services
                |> builtins.attrNames
                |> lib.imap1 (
                  i: serviceName:
                  let
                    port = services.${serviceName};
                  in
                  [
                    {
                      name = "caddy_${toString i}";
                      value = "${serviceName}.${cfg.baseSiteAddress}";
                    }
                    {
                      name = "caddy_${toString i}.reverse_proxy";
                      value = "{{upstreams ${toString port}}}";
                    }
                  ]
                )
                |> lib.concatLists
                |> lib.listToAttrs;
            in
            mkCaddyLabels {
              ${qbittorrentName} = 8080;
              ${clonarrName} = 6060;
              ${prowlarrName} = 9696;
              ${radarrName} = 7878;
              ${radarrAnimeName} = 7879;
              ${sonarrName} = 8989;
              ${sonarrAnimeName} = 8990;
            };
          # starrs-prowlarr: a little hack for bypassing Cloudflare
          addHosts = [
            "bearbit.org:128.1.35.170"
            "www.bearbit.org:128.1.35.170"
          ];
        };

        # Downloader: qBittorrent (will be used by Radarr/Sonarr)
        #
        # IMPORTANT: See "qBittorrent - Basic Setup (TRaSH Guides)" in README.md
        containers.${qbittorrentName}.containerConfig = {
          pod = podRef;
          image = cfg.qbittorrentImage;
          environments = commmonEnvs // {
            TORRENTING_PORT = cfg.torrentingPort;
          };
          volumes = [
            "${cfg.baseConfigDir}/${qbittorrentName}/config:/config"
            torrentsDataVolumeMount
          ];
          memory = "2G"; # explicitly limit to 2GB of RAM
        };

        # Guide Sync (configuration management)
        containers.${clonarrName}.containerConfig = {
          pod = podRef;
          image = cfg.clonarrImage;
          environments = commmonEnvs;
          volumes = [
            "${cfg.baseConfigDir}/${clonarrName}/config:/config"
          ];
        };

        # Indexer Proxies (for bypassing Cloudflare blocks on indexers)
        containers.${byparrName}.containerConfig = {
          pod = podRef;
          image = cfg.byparrImage;
        };

        # Indexer
        containers.${prowlarrName}.containerConfig = {
          pod = podRef;
          image = cfg.prowlarrImage;
          environments = commmonEnvs;
          volumes = [
            "${cfg.baseConfigDir}/${prowlarrName}/config:/config"
          ];
        };

        # Movies (Main)
        containers.${radarrName}.containerConfig = {
          pod = podRef;
          image = cfg.radarrImage;
          environments = commmonEnvs // {
            RADARR__SERVER__PORT = "7878"; # Radarr default
          };
          volumes = [
            "${cfg.baseConfigDir}/${radarrName}/config:/config"
            dataVolumeMount
          ];
        };

        # Movies (Anime)
        containers.${radarrAnimeName}.containerConfig = {
          pod = podRef;
          image = cfg.radarrImage;
          environments = commmonEnvs // {
            RADARR__SERVER__PORT = "7879"; # Radarr default + 1
          };
          volumes = [
            "${cfg.baseConfigDir}/${radarrAnimeName}/config:/config"
            dataVolumeMount
          ];
        };

        # TV Series (Main)
        containers.${sonarrName}.containerConfig = {
          pod = podRef;
          image = cfg.sonarrImage;
          environments = commmonEnvs // {
            SONARR__SERVER__PORT = "8989"; # Sonarr default
          };
          volumes = [
            "${cfg.baseConfigDir}/${sonarrName}/config:/config"
            dataVolumeMount
          ];
        };

        # TV Series (Anime)
        containers.${sonarrAnimeName}.containerConfig = {
          pod = podRef;
          image = cfg.sonarrImage;
          environments = commmonEnvs // {
            SONARR__SERVER__PORT = "8990"; # Sonarr default + 1
          };
          volumes = [
            "${cfg.baseConfigDir}/${sonarrAnimeName}/config:/config"
            dataVolumeMount
          ];
        };
      };
    };
}
