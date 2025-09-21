{
  pkgs,
  lib,
  config,
  ...
}:
let
  utils = import ../utils.nix;
  dotfiles = [
    [
      ".config/aerospace"
      "aerospace"
    ]
    [
      ".config/karabiner"
      "karabiner"
    ]
  ];
in
{
  home = {
    packages = with pkgs; [
      gawk
      discord
      aerospace
      mas
      raycast
      spotify
    ];
    file = utils.mk_symlinks { inherit config dotfiles; };

    activation.applications = utils.mkAppAliasHome {
      derivationName = "home-applications";
      appsPath = config.home.packages;
      outputDir = "${config.home.homeDirectory}/Applications/Nix";
      pkgs = pkgs;
      lib = lib;
    };
  };
}
