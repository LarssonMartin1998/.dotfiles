{ apple-silicon-support, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    apple-silicon-support.nixosModules.apple-silicon-support
  ];

  boot = {
    consoleLogLevel = 0;
    kernelParams = [ "apple_dcp.show_notch=1" ];
    loader.efi.canTouchEfiVariables = false;
  };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      setupAsahiSound = true;
      withRust = true;
    };

    graphics.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  networking.hostName = "asahi-nixos";

  networking = {
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = true;
    };
  };

  services = {
    tlp.enable = true;
  };

  };

  users.users.larssonmartin = {
    isNormalUser = true;
    home = "/home/larssonmartin";
    extraGroups = [ "wheel" ];
    packages = [ ];
    shell = pkgs.zsh;
  };
}
