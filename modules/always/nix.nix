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

  # NOTE: This works for `nix-shell`.
  # But for `nix shell`, you still beed to use a workaround:
  # `$ NIXPKGS_ALLOW_UNFREE=1 nix shell --impure ...`
  # See https://github.com/NixOS/nixpkgs/issues/166220
  nixpkgs.config.allowUnfree = true;
}
