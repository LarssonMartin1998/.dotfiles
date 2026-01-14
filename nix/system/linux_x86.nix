{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./common/nvidia.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false; # lanzaboote replaces systemd-boot module
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  networking.hostName = "walnut-nixos";

  environment = {
    systemPackages = with pkgs; [
      sbctl
    ];
  };

  programs = {
    sway.extraOptions = [
      "--unsupported-gpu"
    ];
    steam.enable = true;
  };
}
