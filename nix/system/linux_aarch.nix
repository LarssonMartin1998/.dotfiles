{ apple-silicon-support, pkgs, ... }:
{
  imports = [
    apple-silicon-support.nixosModules.apple-silicon-support
  ];

  boot = {
    kernelParams = [ "apple_dcp.show_notch=0" ];
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
    tlp.enable = true;
  };
}
