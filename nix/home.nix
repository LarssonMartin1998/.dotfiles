{ pkgs, ... }: {
    home = {
	    stateVersion = "24.05";
        programs = {
            zsh = {
                enable = true;
            };
        };
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
        ];
        file = {
            ".zshrc".source = zsh/.zshrc;
        };
    };
}
