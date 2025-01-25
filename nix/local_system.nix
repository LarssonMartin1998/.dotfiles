{
  pkgs,
  config,
  self,
  nix-homebrew,
  ...
}:
{
  system = {
    stateVersion = 5;
  };

  nix-homebrew.user = "larssonmartin1998-mac";
}
