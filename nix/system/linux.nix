{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  programs = {
    zsh.enable = true;
  };

  boot = {
    consoleLogLevel = 0;
  };

  hardware = {
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

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    displayManager.ly = {
      enable = true;
    };
    timesyncd.enable = true;
    mullvad-vpn.enable = true;
    xserver.enable = true;
  };

  time = {
    timeZone = "Europe/Stockholm";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager
      swaylock-effects
    ];

    variables = {
      NIXOS_OZONE_WL = "1";
    };
  };

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

  users.users.larssonmartin = {
    isNormalUser = true;
    home = "/home/larssonmartin";
    extraGroups = [ "wheel" ];
    packages = [ ];
    shell = pkgs.zsh;
  };
}
