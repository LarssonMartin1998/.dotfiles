{ pkgs, ... }: {
    home = {
	    stateVersion = "24.05";
        packages = with pkgs; [
            neovim
            fzf
            bat
            git
            yazi
            zsh
            tmux
            eza
            curl
            wget
            ripgrep
            fd
            jq
            starship
        ];
    };
}
