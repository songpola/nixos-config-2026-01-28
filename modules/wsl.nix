{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  # Enable xdg-open for opening files and URLs in WSL
  environment.systemPackages = lib.mkIf config.wsl.enable [ pkgs.xdg-utils ];
}
