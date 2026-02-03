{
  delib,
  ...
}:
delib.module {
  name = "bootloader.grubEfi";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    boot.loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };
}
