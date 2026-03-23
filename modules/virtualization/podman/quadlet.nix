{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "virtualization.podman.quadlet";

  options = delib.singleCascadeEnableOption;

  nixos.always =
    { cfg, ... }:
    {
      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

      virtualisation.quadlet.enable = cfg.enable;
    };
}
