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

  # Enable virtualization infrastructure
  myconfig.virtualization.docker.enable = true;
  myconfig.virtualization.podman.enable = true;

  # Caddy as reverse proxy for web services
  myconfig.containers.caddy-reverse-proxy.podman = {
    enable = true;
    configDirectory = "/tank/v1/caddy-reverse-proxy/config";
  };

  # Arcane for managing containers
  myconfig.containers.arcane.podman = {
    enable = true;
    address = "arcane.songpola.dev";
    projectsDirectory = "/tank/v1/arcane/projects";
    baseServerUrl = "https://home.songpola.dev";
  };

  # Dozzle for viewing container logs
  myconfig.containers.dozzle.podman = {
    enable = true;
    address = "dozzle.songpola.dev";
  };
}
