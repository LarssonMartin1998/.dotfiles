{ pkgs, lib, ... }:
{
  home = {
    packages = with pkgs; [
      (python311.withPackages (pythonPkgs: [
        pythonPkgs.pip
        pythonPkgs.pipx
        pythonPkgs.setuptools
      ]))
      pcre
      ccache
      mkdocs
    ];
  };

      (python313.withPackages (pythonPkgs: [
        pythonPkgs.pipx
      ]))
  home.activation.installVectorcode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Installing VectorCode with pipx..."
    $DRY_RUN_CMD ${pkgs.python311Packages.pipx}/bin/pipx install --force vectorcode
  '';
}
