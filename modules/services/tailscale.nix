{
  delib,
  homeManagerUser,
  pkgs,
  ...
}:
delib.module {
  name = "services.tailscale";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      openFirewall = true;
      extraSetFlags = [
        "--operator=${homeManagerUser}"
        # NOTE: Tailscale SSH is not compatible with Podman yet
        # https://github.com/tailscale/tailscale/issues/12409
        # https://github.com/tailscale/tailscale/issues/5295
        "--ssh"
      ];
    };
  };
}
