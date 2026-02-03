{ delib, ... }:
delib.host {
  name = "prts";
  system = "x86_64-linux";

  nixos.system.stateVersion = "24.11";
  home.home.stateVersion = "24.11";

  nixos.facter.reportPath = ./facter.json;

  myconfig.systemdNetworkdBridge = {
    enable = true;
    bridgeMacAddress = "b4:2e:99:91:b1:10"; # eno1
  };

  myconfig.gpu.nvidia = {
    enable = true;
    useOpenSourceKernelModule = false;
  };

  # Network Optimizations
  myconfig.netdevFeatures = {
    enable = true;
    interfaceFeatures = {
      "eno1" = {
        # For Tailscale
        # https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes
        # https://tailscale.com/blog/quic-udp-throughput
        rx-udp-gro-forwarding = true;
        rx-gro-list = false;

        # To enable `generic-segmentation-offload`.
        # These dependencies need to be enabled for it to be auto-enabled.
        scatter-gather = true;
        tcp-segmentation-offload = true;
      };
    };
  };
}
