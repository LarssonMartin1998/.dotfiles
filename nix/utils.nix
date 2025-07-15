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
}
