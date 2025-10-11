{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./common/nvidia.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_17;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "walnut-nixos";

  programs = {
    sway.extraOptions = [
      "--unsupported-gpu"
    ];
    steam.enable = true;
  };
}
