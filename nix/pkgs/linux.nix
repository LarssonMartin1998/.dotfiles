{ pkgs, ... }: {
    home = {
        file = {
            ".config/sway".source = ../sway;
        };
    };
}
