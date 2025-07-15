{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = "auto";
      cores = 0;

      builders-use-substitutes = true;
    };

    optimise.automatic = true;

    extraOptions = ''
      keep-going = true
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
