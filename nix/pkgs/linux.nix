{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wl-clipboard-rs
      sway
    ];
    file = {
      ".config/sway".source = ../sway;
    };
  };
}
