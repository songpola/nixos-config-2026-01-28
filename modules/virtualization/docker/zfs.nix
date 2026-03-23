{
  delib,
  ...
}:
delib.module {
  name = "virtualization.docker.zfsStorageDriver";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled = {
    virtualisation.docker.storageDriver = "zfs";
  };
}
