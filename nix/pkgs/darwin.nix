{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      gawk
    ];
    file = {
      ".config/aerospace/aerospace.toml".source =
        config.lib.file.mkOutOfStoreSymlink ../../aerospace/aerospace.toml;
    };
  };
}
