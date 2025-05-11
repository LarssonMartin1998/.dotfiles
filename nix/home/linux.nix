{
  pkgs,
  config,
  ...
}:

let
  utils = import ../utils.nix;
  dotfiles = [
    [
      ".config/sway"
      "sway"
    ]
    [
      ".config/wofi"
      "wofi"
    ]
  ];

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      i3ipc
    ]
  );
in
{
  imports = [
    ./common/firefox.nix
  ];

  home = {
    packages = with pkgs; [
      pythonEnv
      wl-clipboard-rs
      clang
      clang-tools
      gimp3
      ghostty
      mullvad
      thunderbird
      wofi
      grim
      slurp
      pavucontrol
      blueman
      playerctl
    ];

    file = utils.mk_symlinks { inherit config dotfiles; };
  };
}
