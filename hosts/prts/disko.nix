{ delib, ... }:
let
  disk."main" = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-WDS250G3X0C-00SJG0_191679805165_1";
    content = {
      type = "gpt";
      inherit partitions;
    };
  };

  partitions."ESP" = {
    type = "EF00";
    size = "1G";
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/efi";
      mountOptions = [ "umask=0077" ];
    };
  };

  partitions."root" = {
    size = "100%";
    content = {
      type = "btrfs";
      subvolumes = {
        "@" = {
          mountOptions = [ "compress=zstd" ];
          mountpoint = "/";
        };
        "@nix" = {
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
          mountpoint = "/nix";
        };
        "@home" = {
          mountOptions = [ "compress=zstd" ];
          mountpoint = "/home";
        };
      };
    };
  };
in
delib.host {
  name = "prts";

  nixos.disko.devices.disk = disk;
}
