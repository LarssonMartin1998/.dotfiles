{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  users.users.larssonmartin = {
    isNormalUser = true;
    home = "/home/larssonmartin";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
}
