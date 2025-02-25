{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      gawk
      discord
    ];
    file = {
      ".config/aerospace/aerospace.toml".source =
        config.lib.file.mkOutOfStoreSymlink ../../aerospace/aerospace.toml;
    };
  };
}
