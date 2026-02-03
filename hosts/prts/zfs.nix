{
  delib,
  ...
}:
delib.host {
  name = "prts";

  nixos = {
    networking.hostId = "eb8b6756";

    boot.supportedFilesystems = [ "zfs" ];

    boot.zfs = {
      extraPools = [ "tank" ];

      # The `tank` pool was created using "/dev/disk/by-partlabel"
      # TODO: Consider using "/dev/disk/by-id" instead for better stability.
      devNodes = "/dev/disk/by-partlabel";

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
}
