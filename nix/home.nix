{ pkgs, ... }: {
    programs = {
        zsh = {
            enable = true;
        };
    };
    home = {
	    stateVersion = "24.05";
        packages = with pkgs; [
            neovim
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
        ];
        file = {
            ".zshrc".source = ../zsh/.zshrc;
            ".config/nvim".source = ../nvim;
            ".config/yazi".source = ../yazi;
            ".config/starship.toml".source = ../starship/starship.toml;
            ".tmux.conf".source = ../tmux/.tmux.conf;
            ".config/tmux".source = ../tmux;
            ".config/bat".source = ../bat;
            ".config/ghostty".source = ../ghostty;
            ".config/confutils".source = ../confutils;
        };
    };
}
