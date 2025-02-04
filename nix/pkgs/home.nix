{
  pkgs,
  config,
  neovim-flake,
  ...
}:
let
  dotfiles = [
    [
      ".zshrc"
      "zsh/.zshrc"
    ]
    [
      ".config/nvim"
      "nvim"
    ]
    [
      ".config/yazi"
      "yazi"
    ]
    [
      ".config/starship.toml"
      "starship/starship.toml"
    ]
    [
      ".tmux.conf"
      "tmux/.tmux.conf"
    ]
    [
      ".config/tmux"
      "tmux"
    ]
    [
      ".config/bat"
      "bat"
    ]
    [
      ".config/ghostty"
      "ghostty"
    ]
    [
      ".config/confutils"
      "confutils"
    ]
    [
      ".config/wallpapers"
      "wallpapers"
    ]
  ];

  symlinkFiles = builtins.listToAttrs (
    map (file: {
      name = builtins.elemAt file 0;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/git/.dotfiles/${builtins.elemAt file 1}";
      };

    }) dotfiles
  );
in
{
  programs = {
    zsh = {
      enable = true;
    };
  };

  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      neovim-flake.packages.${system}.neovim
      fzf
      bat
      git
      yazi
      tmux
      eza
      curl
      wget
      ripgrep
      fd
      jq
      starship
      fastfetch
      clang
      clang-tools
      nixfmt-rfc-style
      luajit
      zoxide
      dart
      go
      rustup
      zig
      zls
      nil
      lldb
      gopls
      delve
      golangci-lint
      cmake
      cmake-language-server
      cmake-format
      cmake-lint
      python313Packages.debugpy
      pyright
      lua-language-server
      gnumake
      ninja
      tldr
      nerd-fonts.caskaydia-mono
    ];

    file = symlinkFiles;
  };
}
