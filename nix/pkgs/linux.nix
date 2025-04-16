{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wl-clipboard-rs
      sway
      clang
      clang-tools
    ];
    file = {
      ".config/sway".source = ../sway;
    };
  };
}
