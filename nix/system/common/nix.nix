{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;

      builders-use-substitutes = true;
    };

    extraOptions = ''
      keep-going = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
