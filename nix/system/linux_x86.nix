{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
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
  };

  networking.hostName = "walnut-nixos";

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
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
  };

  services = {
    xserver.videoDrivers = [ "nvidia" ];
  };
}
