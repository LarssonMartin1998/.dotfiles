{ pkgs, config, ... }:
let
  bitwarden_cli = pkgs.bitwarden-cli.overrideAttrs (oldAttrs: {
    stdenv = pkgs.llvmPackages_18.stdenv;
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.llvmPackages_18.stdenv.cc ];
    CXX = "${pkgs.llvmPackages_18.clang}/bin/clang++";
    CC = "${pkgs.llvmPackages_18.clang}/bin/clang";
  });
in
{
  home = {
    packages = with pkgs; [
      gawk
      discord
      bitwarden_cli
    ];
    file = {
      ".config/aerospace/aerospace.toml".source =
        config.lib.file.mkOutOfStoreSymlink ../../aerospace/aerospace.toml;
    };
  };
}
