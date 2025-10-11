{ config, ... }:
{
  boot = {
    kernelParams = [
      "ibt=off"
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
      forceFullCompositionPipeline = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      nvidiaPersistenced = true;
      nvidiaSettings = true;
    };
  };

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
  };
}
