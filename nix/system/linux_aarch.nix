{ apple-silicon-support, ... }:
{
  imports = [
    apple-silicon-support.nixosModules.apple-silicon-support
  ];

  boot = {
    kernelParams = [
      "apple_dcp.show_notch=0"
      "cpuidle.off=0"
      "mem_sleep_default=deep"
    ];
    loader.efi.canTouchEfiVariables = false;
  };

  hardware.asahi = {
    peripheralFirmwareDirectory = ./firmware;
    useExperimentalGPUDriver = true;
    setupAsahiSound = true;
    withRust = true;
  };

  networking.hostName = "asahi-nixos";

  services = {
    tlp = {
      enable = true;
      settings = {
        SOUND_POWER_SAVE_ON_BAT = 1;
        RUNTIME_PM_ON_BAT = "auto";
        WIFI_PWR_ON_BAT = "on";
        WOL_DISABLE = "Y";
      };
    };
  };
}
