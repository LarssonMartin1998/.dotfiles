{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      legcord
      librespot
      spotify-qt
    ];
  };
}
