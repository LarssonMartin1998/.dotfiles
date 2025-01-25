{
  pkgs,
  neovim-flake,
  ...
}:
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
    file = {
      ".zshrc".source = ../../zsh/.zshrc;
      ".config/nvim".source = ../../nvim;
      ".config/yazi".source = ../../yazi;
      ".config/starship.toml".source = ../../starship/starship.toml;
      ".tmux.conf".source = ../../tmux/.tmux.conf;
      ".config/tmux".source = ../../tmux;
      ".config/bat".source = ../../bat;
      ".config/ghostty".source = ../../ghostty;
      ".config/confutils".source = ../../confutils;
      ".config/wallpapers".source = ../../wallpapers;
    };
  };
}
