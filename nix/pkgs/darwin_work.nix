{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (python311.withPackages (pythonPkgs: [
        pythonPkgs.pip
        pythonPkgs.setuptools
      ]))
      pcre
      ccache
      mkdocs
    ];
  };
}
