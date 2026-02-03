{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "nixos-facter-modules";

  nixos.always.imports = [ inputs.nixos-facter-modules.nixosModules.facter ];
}
