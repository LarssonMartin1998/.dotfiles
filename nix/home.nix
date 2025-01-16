{ pkgs, ... }: {
    home = {
	    stateVersion = "24.05";
        packages = with pkgs; [
            neovim
        ];
    };
}
