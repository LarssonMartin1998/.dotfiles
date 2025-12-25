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
  ];

  programs = {
    zsh.initContent = ''
      # Initialize keychain - will handle keys on-demand
      eval $(keychain --eval --agents ssh)
    '';
  };

  home = {
    packages = with pkgs; [
      pythonEnv
      wl-clipboard-rs
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
      sway-audio-idle-inhibit
      imv
      keychain
      wtype
      kdePackages.qtsvg
      kdePackages.dolphin
      nextcloud-client
    ];

    file = utils.mk_symlinks { inherit config dotfiles; };
  };
  services = {
    wlsunset = {
      enable = true;
      sunrise = "07:00";
      sunset = "20:00-22:00";

      temperature = {
        day = 6500;
        night = 3500;
      };
    };
    mako.enable = true;
    ssh-agent.enable = true;
  };
}
