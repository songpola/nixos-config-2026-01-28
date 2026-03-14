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

  myconfig.services.docker.enable = true;
}
