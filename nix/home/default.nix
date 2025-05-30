{
  pkgs,
  config,
  lib,
  neovim-flake,
  ...
}:
let
  utils = import ../utils.nix;
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
    [
      ".config/git"
      "git"
    ]
  ];

  codelldb = pkgs.runCommand "codelldb" { } ''
    mkdir -p $out/bin
    cp ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/codelldb
    chmod +x $out/bin/codelldb
  '';
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
      nixfmt-rfc-style
      luajit
      zoxide
      dart
      go
      rustc
      cargo
      rust-analyzer
      rustfmt
      zig
      zls
      nil
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
      lldb
      nodejs
      tree-sitter
      codelldb
      bottom
      bc
      cmatrix
      svelte-language-server
      diff-so-fancy
      obsidian
      evil-helix
      xh
      dust
      tokei
      just
      presenterm
      rainfrog
      atac
    ];

    file = utils.mk_symlinks { inherit config dotfiles; };
    activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.bat}/bin/bat cache --build
    '';
  };
}
