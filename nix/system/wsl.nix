{ nixos-wsl, pkgs, ... }:
{
  imports = [
    nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
