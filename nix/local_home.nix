{ ... }:
{
  # local_home.nix
  # This is a template file that is committed to git with minimal changes.
  # In order to use this and remain pure, each machine needs to create a local branch, i.e `machine-wsl` and set these variables
  # accordingly, and then commit it.
  home = {
    # Stub values for demonstration. Override these in local branch.
    username = "martin.larsson";
    homeDirectory = "/Users/martin.larsson";
  };
}
