{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    consoleLogLevel = 0;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      nvidiaPersistenced = true;

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

  networking.hostName = "walnut-nixos";

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

  programs = {
    xwayland.enable = true;
    sway = {
      enable = true;
      package = pkgs.swayfx;
      extraOptions = [
        "--unsupported-gpu"
      ];
    };
  };

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
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
