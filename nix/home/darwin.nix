{
  pkgs,
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
  ];
in
{
  home = {
    packages = with pkgs; [
      gawk
      discord
    ];
    file = utils.mk_symlinks { inherit config dotfiles; };
  };
}
