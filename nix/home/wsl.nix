{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wslu
      llvmPackages_20.clang
      llvmPackages_20.clang-tools
    ];
  };
}
