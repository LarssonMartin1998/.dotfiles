{
  pkgs,
  ...
}:
let
  discord_wrapped = pkgs.writeShellScriptBin "discord" ''
    #!${pkgs.runtimeShell}
    exec "${pkgs.discord}/bin/discord" "$@" >/dev/null 2>&1
  '';
in
{
  home = {
    packages = with pkgs; [
      discord_wrapped
      spotify
    ];
  };
}
