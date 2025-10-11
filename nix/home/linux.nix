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
      # Just ensure SSH agent is available, don't preload keys
      if [ ! -S ~/.ssh/ssh_auth_sock ]; then
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock 2>/dev/null
      fi
      export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    '';
  };

  home = {
    packages = with pkgs; [
      pythonEnv
      wl-clipboard-rs
      llvmPackages_20.clang
      llvmPackages_20.clang-tools
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
