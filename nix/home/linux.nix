{
  pkgs,
  ghosttyPkg,
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
      llvmPackages_20.clang
      llvmPackages_20.clang-tools
      gimp3
      ghosttyPkg
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
      sway-audio-idle-inhibit
      ffmpeg
      imv
    ];

    file = utils.mk_symlinks { inherit config dotfiles; };
  };
  services = {
    mako.enable = true;
  };
}
