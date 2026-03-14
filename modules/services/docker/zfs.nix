{
  delib,
  ...
}:
delib.module {
  name = "services.docker.zfsStorageDriver";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled = {
    virtualisation.docker.storageDriver = "zfs";
  };
}
