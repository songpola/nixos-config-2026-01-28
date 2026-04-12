{
  delib,
  inputs,
  # lib,
  # secrets,
  ...
}:
# let
#   secret = "CF_DNS_API_TOKEN";
#   secretPath = secrets.${secret}.path;
# in
delib.module {
  name = "services.dokploy";

  options = delib.singleEnableOption false;

  # myconfig.ifEnabled = {
  #   secrets.${secret}.sopsFile = ./secrets.sops.yaml;

  #   apps.docker.enable = true;
  # };

  nixos.always.imports = [ inputs.nix-dokploy.nixosModules.default ];

  myconfig.ifEnabled = {
    virtualization.docker.enable = true;
  };

  nixos.ifEnabled = {
    virtualisation.docker.daemon.settings.live-restore = false;

    services.dokploy = {
      enable = true;
      database.useInsecureHardcodedPassword = true;
      # database.passwordFile = "/var/lib/secrets/dokploy-db-password";
    };

    # services.dokploy.traefik.extraArgs = lib.concatStringsSep " " [
    #   "-v ${secretPath}:${secretPath}"
    #   "-e CF_DNS_API_TOKEN_FILE=${secretPath}"
    #   "--add-host=host.docker.internal:host-gateway"
    # ];

    networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}
