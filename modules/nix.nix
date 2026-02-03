{ homeManagerUser, inputs, ... }:
{
  nix = {
    channel.enable = false;

    registry = {
      "self".flake = inputs.self;
      "unstable".to = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable";
      };
      "tmpl".to = {
        type = "github";
        owner = "songpola";
        repo = "templates";
      };
    };

    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];

      # To prevent the `error: cannot ... because it lacks a signature by a trusted key`
      trusted-users = [ homeManagerUser ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
