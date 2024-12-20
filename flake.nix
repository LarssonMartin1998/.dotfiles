{
	description = "";

	inputs = {
		# Used for system packages
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		# Used for MacOS system config
		darwin = {
			url = "github:/lnl7/nix-darwin/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Used for Windows Subsystem for Linux compatibility
		wsl.url = "github:nix-community/NixOS-WSL";

		# Used for user packages and dotfiles
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list where available
		};
	};

	outputs = { nixpkgs, ... }@inputs: 
	let
		# System types to support.
      		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

		# Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
	in rec {
	};
}
