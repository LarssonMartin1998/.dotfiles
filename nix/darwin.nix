{ pkgs, ... }: {
    home = {
        packages = with pkgs; [
	    ghostty

        ];
        file = {
            ".config/ghostty".source = ../ghostty;
        };
    };
}
