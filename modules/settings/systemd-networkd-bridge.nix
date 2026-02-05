{
  delib,
  lib,
  config,
  ...
}:
delib.module {
  name = "settings.systemdNetworkdBridge";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      bridgeName = strOption "br0";
      bridgeMacAddress = allowNull (strOption null);
      memberInterfaces = noNullDefault (
        listOfOption str (config.facter.detected.dhcp.interfaces or null)
      );
    };

  nixos.ifEnabled =
    { cfg, ... }:
    lib.mkMerge [
      {
        # Force disable DHCP option from nixos-facter-modules
        facter.detected.dhcp.enable = lib.mkForce false;

        # The DHCP will be handled by the bridge
        networking.useDHCP = false;

        # Reference: https://wiki.archlinux.org/title/Systemd-networkd#Network_bridge_with_DHCP
        systemd.network = {
          enable = true;

          # Since systemd v256
          config.networkConfig = {
            IPv4Forwarding = "yes";
            IPv6Forwarding = "yes";
          };

          # Define the bridge network device
          netdevs."10-${cfg.bridgeName}".netdevConfig = {
            Name = cfg.bridgeName;
            Kind = "bridge";
          }
          // lib.optionalAttrs (cfg.bridgeMacAddress != null) {
            # NOTE: There's no need to define the `links` to set MACAddressPolicy,
            # because NixOS doesn’t have the 99-default.link file,
            # nothing else will override your MAC (no MACAddressPolicy=persistent).
            MACAddress = cfg.bridgeMacAddress;
          };

          # Configure the bridge network
          networks."20-${cfg.bridgeName}" = {
            matchConfig.Name = cfg.bridgeName;
            networkConfig = {
              DHCP = "yes";
              UseDomains = "yes";
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };
      }
      {
        # Configure member interfaces of the bridge
        systemd.network.networks = lib.genAttrs' cfg.memberInterfaces (name: {
          name = "30-${cfg.bridgeName}-${name}";
          value = {
            matchConfig.Name = name;
            networkConfig.Bridge = cfg.bridgeName;
            linkConfig.RequiredForOnline = "enslaved";
          };
        });
      }
    ];
}
