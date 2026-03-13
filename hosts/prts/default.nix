{ delib, ... }:
delib.host {
  name = "prts";
  system = "x86_64-linux";
  type = "server";
  features = [ "nvidia" ];

  nixos.system.stateVersion = "24.11";
  home.home.stateVersion = "24.11";

  # Disko configs: ./disko.nix

  # Hardware configs
  nixos.facter.reportPath = ./facter.json;

  # Use ZRAM as swap (no swap partition)
  nixos.zramSwap.enable = true;

  # GRUB EFI Bootloader
  myconfig.bootloader.grubEfi.enable = true;

  # Use systemd-networkd bridge
  myconfig.settings.systemdNetworkdBridge = {
    enable = true;
    bridgeMacAddress = "b4:2e:99:91:b1:10"; # eno1
  };

  # GTX 1050 Ti does not support open-source kernel module
  myconfig.gpu.nvidia.useOpenSourceKernelModule = false;

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

  # Enable Tailscale with subnet routing and exit node features
  myconfig.services.tailscale.enable = true;
  nixos.services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--advertise-routes=10.0.0.0/16"
      "--advertise-exit-node"
    ];
  };
}
