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
    [
      ".config/mako"
      "mako"
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
    ./common/theming.nix
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
      mako
      bitwarden-cli
    ];

    file = utils.mk_symlinks { inherit config dotfiles; };
  };
  services = {
    mako.enable = true;
  };
}
