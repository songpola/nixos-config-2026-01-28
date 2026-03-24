{
  delib,
  homeManagerUser,
  pkgs,
  config,
  lib,
  ...
}:
delib.module {
  name = "services.tailscale";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      openFirewall = true;
      extraSetFlags = [
        "--operator=${homeManagerUser}"
        # NOTE: Tailscale SSH is not compatible with Podman yet
        # https://github.com/tailscale/tailscale/issues/12409
        # https://github.com/tailscale/tailscale/issues/5295
        "--ssh"
      ];
    };

    # Ref: https://github.com/tailscale/tailscale/issues/4639#issuecomment-1492942183
    services.firewalld.zones = {
      # Accept all inbound traffic from Tailscale
      trusted.interfaces = [ config.services.tailscale.interfaceName ];
      # Allow outbound traffic from Tailscale to the internet
      # (masquerading as the host's IP address)
      nixos-fw-default =
        lib.mkIf
          (
            config.services.tailscale.useRoutingFeatures == "server"
            || config.services.tailscale.useRoutingFeatures == "both"
          )
          {
            masquerade = true;

            # Syntax: https://www.xml.com/pub/a/2006/05/31/converting-between-xml-and-json.html
            # Converter: https://pypi.org/project/xmltodict/
            rules = [
              {
                "@family" = "ipv6"; # an argument
                "masquerade" = ""; # an empty tag (content)
              }
            ];
          };
    };
  };
}
