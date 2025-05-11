{
  pkgs,
  ...
}:
{
  imports = [
    ./common/spotify_arm.nix
  ];

  home = {
    packages = with pkgs; [
      legcord
    ];
  };
}
