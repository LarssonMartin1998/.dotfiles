{ config, pkgs }:

{
	home.username = "larssonmartin";
	home.homeDirectory = "home/larssonmartin";

	home.stateVersion = "24.11";

	programs.home-manager.enable = true;
}
