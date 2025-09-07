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

  mkFswatchService =
    {
      pkgs,
      lib,
      config,
      isLinux,
      isDarwin,

      name,
      scriptPath,
      root,
      description ? "Register ${name}.",
    }:
    let
      fswatchLatencyArg = if isDarwin then "--latency=0.2" else "";
      scriptPkg = pkgs.writeShellScriptBin "${name}" ''
        set -euo pipefail

        ROOT="${root}"
        SCRIPT="${scriptPath}"
        FSWATCH="${pkgs.fswatch}/bin/fswatch"
        FSWATCH_LATENCY_ARG="${fswatchLatencyArg}"

        "$FSWATCH" $FSWATCH_LATENCY_ARG --event=Updated --event=Created --event=Removed --event=Renamed -o --exclude '\.DS_Store$' "$ROOT" | xargs -n1 "$SCRIPT"
      '';

      baseBinPath = lib.makeBinPath [
        pkgs.findutils
        pkgs.fswatch
        pkgs.bash
        pkgs.coreutils
      ];

      pathForService = lib.concatStringsSep ":" [
        baseBinPath
        "${config.home.profileDirectory}/bin"
        "/etc/profiles/per-user/${config.home.username}/bin"
        "/opt/homebrew/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/bin"
      ];

      linuxAttrs = lib.optionalAttrs isLinux {
        systemd.user.startServices = "sd-switch";
        systemd.user.services."${name}" = {
          Unit = {
            Description = description;
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            Restart = "always";
            RestartSec = "5s";
            ExecStart = "${scriptPkg}/bin/${name}";
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
        launchd.agents."${name}" = {
          enable = true;
          config = {
            ProgramArguments = [ "${scriptPkg}/bin/${name}" ];
            RunAtLoad = true;
            KeepAlive = true;
            EnvironmentVariables = {
              PATH = pathForService;
            };
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${name}.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${name}.err";
          };
        };
      };
    in
    linuxAttrs // darwinAttrs;
}
