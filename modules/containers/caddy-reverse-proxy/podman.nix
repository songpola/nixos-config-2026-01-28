{
  delib,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.virtualisation.quadlet) networks;

  ingressNetwork = "caddy-reverse-proxy-ingress";
in
delib.module {
  name = "containers.caddy-reverse-proxy.podman";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      configDirectory = noDefault (pathOption null);
    };

  myconfig.always =
    { cfg, ... }:
    {
      args.shared = {
        addCaddyReverseProxyConfig =
          {
            address, # set this to null to force no-op
            protocol ? null,
            port ? null,
            upstreams ? "{{${
              [ "upstreams" ]
              ++ lib.optional (protocol != null) protocol
              ++ lib.optional (port != null) (toString port)
              |> lib.concatStringsSep " "
              |> lib.trim
            }}}",
          }:
          if cfg.enable && address != null then
            target: # (targetContainerConfig)
            lib.recursiveUpdate target {
              networks = (target.networks or [ ]) ++ [ networks.${ingressNetwork}.ref ];
              labels = (target.labels or { }) // {
                "caddy" = address;
                "caddy.reverse_proxy" = upstreams;
              };
            }
          else
            lib.id; # no-op if caddy is not enabled or address is null
      };
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      inherit (config.virtualisation.quadlet) volumes;
      inherit (config.sops) secrets;

      dataVolume = "caddy-reverse-proxy-data";

      secret = "caddy-reverse-proxy/CLOUDFLARE_API_TOKEN";
      secretPath = secrets.${secret}.path;

      caddyfile = pkgs.writeText "Caddyfile" ''
        {
          email songpola@songpola.dev
          acme_dns cloudflare {file.${secretPath}}
        }
      '';
    in
    {
      sops.secrets.${secret}.sopsFile = ./secrets.yaml;

      virtualisation.quadlet = {
        enable = true;
        containers."caddy-reverse-proxy".containerConfig = {
          image = "docker.io/homeall/caddy-reverse-proxy-cloudflare:latest";
          publishPorts = [
            "80:80" # HTTP
            "443:443" # HTTPS
            "443:443/udp" # HTTP3
          ];
          volumes = [
            "%t/podman/podman.sock:/var/run/docker.sock"
            "${cfg.configDirectory}:/config"
            "${volumes.${dataVolume}.ref}:/data"
            "${caddyfile}:/config/Caddyfile"
            "${secretPath}:${secretPath}"
          ];
          environments = {
            CADDY_INGRESS_NETWORKS = ingressNetwork;
            CADDY_DOCKER_NO_SCOPE = "true"; # for podman compatibility
            # Ref: https://github.com/lucaslorentz/caddy-docker-proxy/blob/master/tests/caddyfile%2Bconfig/compose.yaml
            CADDY_DOCKER_CADDYFILE_PATH = "/config/Caddyfile";
          };
          networks = [ networks.${ingressNetwork}.ref ];
          # The image don't have HEALTHCHECK
          # but caddy supports sd_notify
          notify = true;
        };
        volumes.${dataVolume} = { };
        networks.${ingressNetwork} = { };
      };
    };
}
