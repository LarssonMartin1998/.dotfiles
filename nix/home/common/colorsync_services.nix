{
  pkgs,
  lib,
  config,
  isLinux,
  isDarwin,
  ...
}:
let
  utils = import ../../utils.nix;

  name = "colorsync-scriptrunner";
  colorsyncScriptWrapper = pkgs.writeShellScriptBin "${name}-wrapper" ''
    set -euo pipefail

    echo colorsync-scriptrunner is executing
    "$HOME/.config/tmux/tmux-statusbar-color.sh"
    "$HOME/.config/ghostty/ghostty-change-theme.sh"
  '';
  root = "$HOME/.local/state/colorsync/current";
in
lib.mkMerge [
  (utils.mkFswatchService {
    inherit
      pkgs
      lib
      config
      isLinux
      isDarwin
      ;
    name = name;
    scriptPath = "${colorsyncScriptWrapper}/bin/${name}-wrapper";
    root = root;
    description = "Run colorsync-scriptrunner after ${root} changes.";
  })
]
