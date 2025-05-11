{
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
}
