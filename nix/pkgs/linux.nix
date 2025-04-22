{ pkgs, lib, ... }:
{
  home = {
    packages = with pkgs; [
      (python313.withPackages (pythonPkgs: [
        pythonPkgs.pipx
      ]))
      wl-clipboard-rs
      sway
      clang
      clang-tools
    ];
    home.activation.installVectorcode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Installing VectorCode with pipx..."
      $DRY_RUN_CMD ${pkgs.python311Packages.pipx}/bin/pipx install --force vectorcode
    '';
    file = {
      ".config/sway".source = ../sway;
    };
  };
}
