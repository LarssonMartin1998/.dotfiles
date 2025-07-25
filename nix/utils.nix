rec {
  mk_symlinks =
    {
      config,
      basePath ? "${config.home.homeDirectory}/dev/git/.dotfiles",
      dotfiles ? [ ],
    }:
    builtins.listToAttrs (
      map (file: {
        name = builtins.elemAt file 0;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${basePath}/${builtins.elemAt file 1}";
        };
      }) dotfiles
    );

  mkAppAliasSystem = args: args.pkgs.lib.mkForce (mkAppAliasScriptContent args);
  mkAppAliasHome =
    args: args.lib.hm.dag.entryAfter [ "writeBoundary" ] (mkAppAliasScriptContent args);

  # Darwin System / Home Manager expects activation scripts in different formats
  # This only return the script body, use the other two functions in the config.
  mkAppAliasScriptContent =
    {
      derivationName,
      appsPath,
      outputDir,
      pkgs,
      lib,
    }:
    let
      env = pkgs.buildEnv {
        name = derivationName;
        paths = appsPath;
        pathsToLink = "/Applications";
      };
    in
    ''
      echo "Setting up macOS .app aliases..." >&2
      rm -rf "${outputDir}"
      mkdir -p "${outputDir}"

      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        ${pkgs.mkalias}/bin/mkalias "$src" "${outputDir}/$app_name"
      done
    '';

  mkWatchmanTrigger =
    {
      pkgs,
      lib,
      config,
      isLinux,
      isDarwin,

      name,
      triggerName,
      scriptPath,

      root ? "$HOME/.local/state/colorsync",
      description ? "Register watchman trigger for ${name}.",
      watchExpr ? "current",
    }:
    let
      serviceName = "${name}-watchman";
      # e.g. tmux-watchman-statuscolor, ghostty-watchman-theme
      binName =
        let
          trig = lib.replaceStrings [ "_" ] [ "-" ] triggerName;
        in
        "${serviceName}-${trig}";

      scriptPkg = pkgs.writeShellScriptBin binName ''
        set -euo pipefail

        ROOT="${root}"
        TRIGGER_NAME="${triggerName}"
        SCRIPT="${scriptPath}"
        WATCHMAN="${pkgs.watchman}/bin/watchman"

        "$WATCHMAN" -- watch-project "$ROOT" >/dev/null
        "$WATCHMAN" -- trigger-del "$ROOT" "$TRIGGER_NAME" >/dev/null 2>&1 || true
        "$WATCHMAN" -- trigger "$ROOT" "$TRIGGER_NAME" ${watchExpr} -- bash "$SCRIPT"
      '';

      pathForService = lib.makeBinPath [
        pkgs.watchman
        pkgs.bash
        pkgs.coreutils
      ];

      linuxAttrs = lib.optionalAttrs isLinux {
        systemd.user.startServices = "sd-switch";
        systemd.user.services."${serviceName}" = {
          Unit = {
            Description = description;
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${scriptPkg}/bin/${binName}";
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
        launchd.agents."${serviceName}" = {
          enable = true;
          config = {
            ProgramArguments = [ "${scriptPkg}/bin/${binName}" ];
            RunAtLoad = true;
            KeepAlive = false;
            EnvironmentVariables = {
              PATH = pathForService;
            };
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${serviceName}.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${serviceName}.err";
          };
        };
      };
    in
    linuxAttrs // darwinAttrs;
}
