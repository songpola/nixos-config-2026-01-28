{
  delib,
  lib,
  pkgs,
  ...
}:
# TODO: Wait until systemd v260 released with this PR:
# https://github.com/systemd/systemd/pull/40325
# https://github.com/systemd/systemd/issues/39318
# Then migrate to systemd-networkd native support for this feature.
delib.module {
  name = "netdevFeatures";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      interfaceFeatures = attrsOfOption (submodule {
        options =
          let
            boolOrNullOption = allowNull (boolOption null);
          in
          {
            rx-udp-gro-forwarding = boolOrNullOption;
            rx-gro-list = boolOrNullOption;
            scatter-gather = boolOrNullOption;
            tcp-segmentation-offload = boolOrNullOption;
          };
      }) { };
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      # Map long feature names to their ethtool abbreviations
      ethtoolFeatureAbbreviations = {
        scatter-gather = "sg";
        tcp-segmentation-offload = "tso";
      };

      # Convert feature name to ethtool format (use abbreviation if available)
      normalizeFeatureName =
        feature:
        if lib.hasAttr feature ethtoolFeatureAbbreviations then
          ethtoolFeatureAbbreviations.${feature}
        else
          feature;

      # Convert features attrset to ethtool command arguments string
      buildFeatureArgs =
        features:
        let
          enabledFeatures = lib.filterAttrs (_: enabled: enabled != null) features;
          featureFlags = lib.mapAttrsToList (
            feature: enabled: "${normalizeFeatureName feature} ${if enabled then "on" else "off"}"
          ) enabledFeatures;
        in
        lib.concatStringsSep " " featureFlags;

      # Generate ethtool command for a single interface
      buildEthtoolCommand =
        interfaceName: features:
        let
          featureArgs = buildFeatureArgs features;
        in
        "${lib.getExe pkgs.ethtool} -K ${interfaceName} ${featureArgs}";

      # Generate all ethtool commands for all configured interfaces
      generateAllCommands =
        let
          interfaceCommands = lib.mapAttrsToList buildEthtoolCommand cfg.interfaceFeatures;
        in
        lib.concatStringsSep "\n" interfaceCommands;
    in
    {
      systemd.services."set-netdev-features" = {
        description = "Set network device features";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = lib.getExe (
            pkgs.writeShellApplication {
              name = "systemd-services-set-netdev-features";
              text = generateAllCommands;
            }
          );
        };
      };
    };
}
