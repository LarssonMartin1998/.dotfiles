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
in
lib.mkMerge [
  (utils.mkWatchmanTrigger {
    inherit
      pkgs
      lib
      config
      isLinux
      isDarwin
      ;
    name = "ghostty";
    triggerName = "ghostty_theme";
    scriptPath = "$HOME/.config/ghostty/ghostty-change-theme.sh";
    description = "Register watchman trigger for Ghostty themes.";
  })
  (utils.mkWatchmanTrigger {
    inherit
      pkgs
      lib
      config
      isLinux
      isDarwin
      ;
    name = "tmux";
    triggerName = "tmux_statusbar_color";
    scriptPath = "$HOME/.config/tmux/tmux-statusbar-color.sh";
    description = "Register watchman trigger for Tmux statusbar colors.";
  })
]
