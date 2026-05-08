{
  delib,
  pkgs,
  ...
}:
delib.host {
  name = "prts";

  nixos = {
    networking.hostId = "eb8b6756";

    boot.supportedFilesystems = [ "zfs" ];

    boot.zfs = {
      # TODO 2026-05-09: Wait until next stable release or until `pkgs.zfs = pkgs.zfs_2_4`
      package = pkgs.zfs_2_4; # ensure to be v2.4.1+

      extraPools = [ "tank" ];

      devNodes = "/dev/disk/by-id";

      # Forcibly import the ZFS root pool(s) during early boot.
      #
      # This is enabled by default for backwards compatibility purposes,
      # but it is HIGHLY RECOMMENDED to DISABLE this option,
      # as it bypasses some of the safeguards ZFS uses to protect your ZFS pools.
      #
      # If you set this option to false and NixOS subsequently fails to boot because it cannot import the root pool,
      # you should boot with the zfs_force=1 option as a kernel parameter (e.g. by manually editing the kernel params in grub during boot).
      # You should only need to do this once.
      forceImportRoot = false;
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };

  # The `tank/docker` dataset is mounted on `/var/lib/docker`
  myconfig.virtualization.docker.zfsStorageDriver.enable = true;
  myconfig.virtualization.podman.zfsStorageDriver.enable = true;
  myconfig.virtualization.podman.zfsStorageDriver.dataset = "tank/unmanaged/podman";
}
