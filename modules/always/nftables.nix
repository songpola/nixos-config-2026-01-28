{ host, ... }:
{
  # Use nftables instead of iptables by default, except on WSL
  # (since nftables doesn't work well on WSL).
  networking.nftables.enable = (!host.isWsl);
}
