{ pkgs, ... }:
{
    home = {
        stateVersion = "24.05";
        file = {
            ".config/sway".source = ../sway;
        };
    };
}
