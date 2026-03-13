{
  delib,
  ...
}:
delib.host {
  name = "prts";

  myconfig.services.tailscale.enable = true;

  nixos.services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--advertise-routes=10.0.0.0/16"
      "--advertise-exit-node"
    ];
  };

  # Network optimizations
  myconfig.settings.netdevFeatures = {
    enable = true;
    interfaceFeatures."eno1" = {
      # For Tailscale
      # https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes
      # https://tailscale.com/blog/quic-udp-throughput
      rx-udp-gro-forwarding = true;
      rx-gro-list = false;

      # To enable `generic-segmentation-offload`,
      # these dependencies need to be enabled for it to be auto-enabled.
      scatter-gather = true;
      tcp-segmentation-offload = true;
    };
  };
}
