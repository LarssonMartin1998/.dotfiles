{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wslu
      clang
      clang-tools
    ];
  };
}
