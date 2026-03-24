{
  host,
  lib,
  inputs,
  ...
}:
{
  # Use nftables instead of iptables by default, except on WSL
  # (since nftables doesn't work well on WSL).
  networking.nftables.enable = (!host.isWsl);

  # Use firewalld, except on WSL (firewalld depends on nftables, which doesn't work well on WSL).
  services.firewalld.enable = lib.mkIf (!host.isWsl) true;

  # TODO: Remove this once the PR is merged and included in a release.
  # https://github.com/NixOS/nixpkgs/issues/502922
  # https://github.com/NixOS/nixpkgs/pull/502926
  disabledModules = [ "services/networking/firewalld/settings.nix" ];
  imports = [
    "${inputs.pr-firewalld}/nixos/modules/services/networking/firewalld/settings.nix"
  ];
}
