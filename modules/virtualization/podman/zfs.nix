{
  delib,
  ...
}:
delib.module {
  name = "virtualization.podman.zfsStorageDriver";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption parent.enable;

        dataset = noDefault (strOption null);
      }
    );

  nixos.ifEnabled =
    { cfg, ... }:
    {
      virtualisation.containers.storage.settings = {
        storage.driver = "zfs";
        storage.options.zfs.fsname = cfg.dataset;
      };
    };
}
