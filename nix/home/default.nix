{
  pkgs,
  config,
  lib,
  neovim-flake,
  colorsync,
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
      ".config/helix"
      "helix"
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
    [
      ".config/colorsync"
      "colorsync"
    ]
  ];

  codelldb = pkgs.runCommand "codelldb" { } ''
    mkdir -p $out/bin
    cp ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/codelldb
    chmod +x $out/bin/codelldb
  '';
in
{
  imports = [
    ./common/colorsync_services.nix
    ./common/firefox.nix
  ];

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
      luajitPackages.jsregexp
      zoxide
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
      basedpyright
      lua-language-server
      typescript-language-server
      vscode-langservers-extracted
      tailwindcss-language-server
      prettier
      eslint_d
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
      helix
      xh
      dust
      tokei
      just
      presenterm
      rainfrog
      atac
      p7zip
      colorsync
      fswatch
      ffmpeg
    ];

    file = utils.mk_symlinks { inherit config dotfiles; };
    activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.bat}/bin/bat cache --build
    '';
  };
}
