{ delib, ... }:
delib.host {
  name = "prts";
  system = "x86_64-linux";

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
  myconfig.systemdNetworkdBridge = {
    enable = true;
    bridgeMacAddress = "b4:2e:99:91:b1:10"; # eno1
  };

  # NVIDIA GPU
  myconfig.gpu.nvidia = {
    enable = true;
    useOpenSourceKernelModule = false;
  };

  # Network optimizations
  myconfig.netdevFeatures = {
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

  # Auto-login on Linux console (getty)
  myconfig.consoleAutoLogin.enable = true;

  # Allow "wheel" group members to use `sudo` without password
  myconfig.wheelNoPassword.enable = true;

  myconfig.programs = {
    ssh.enable = true;
    ov.enable = true;
  };
}
