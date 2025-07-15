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
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };
  };
}
