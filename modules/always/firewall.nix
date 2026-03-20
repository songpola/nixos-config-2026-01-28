{ host, lib, ... }:
{
  # Use nftables instead of iptables by default, except on WSL
  # (since nftables doesn't work well on WSL).
  networking.nftables.enable = (!host.isWsl);

  # Use firewalld, except on WSL (firewalld depends on nftables, which doesn't work well on WSL).
  services.firewalld.enable = lib.mkIf (!host.isWsl) true;
}
