{
  pkgs,
  lib,
  config,
  isLinux,
  isDarwin,
  ...
}:

let
  scriptPkg = pkgs.writeShellScriptBin "tmux-watchman-statuscolor" ''
    set -euo pipefail

    ROOT="$HOME/.local/state/colorsync"
    TRIGGER_NAME="tmux_statusbar_color"
    SCRIPT="$HOME/.config/tmux/tmux-statusbar-color.sh"
    WATCHMAN="${pkgs.watchman}/bin/watchman"

    "$WATCHMAN" -- watch-project "$ROOT" >/dev/null
    "$WATCHMAN" -- trigger-del "$ROOT" "$TRIGGER_NAME" >/dev/null 2>&1 || true
    "$WATCHMAN" -- trigger "$ROOT" "$TRIGGER_NAME" current -- bash "$SCRIPT"
  '';

  pathForService = lib.makeBinPath [
    pkgs.watchman
    pkgs.bash
    pkgs.coreutils
  ];

  linuxAttrs = lib.optionalAttrs isLinux {
    systemd.user.startServices = "sd-switch";
    systemd.user.services.tmux-watchman = {
      Unit = {
        Description = "Register watchman trigger for tmux statusbar color";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${scriptPkg}/bin/tmux-watchman-statuscolor";
        Environment = [ "PATH=${pathForService}" ];
        StandardOutput = "journal";
        StandardError = "journal";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  darwinAttrs = lib.optionalAttrs isDarwin {
    launchd.user.agents.tmux-watchman = {
      enable = true;
      config = {
        ProgramArguments = [ "${scriptPkg}/bin/tmux-watchman-statuscolor" ];
        RunAtLoad = true;
        KeepAlive = false;
        EnvironmentVariables = {
          PATH = pathForService;
        };
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/tmux-watchman.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/tmux-watchman.err";
      };
    };
  };
in
linuxAttrs // darwinAttrs
