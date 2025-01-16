{
    description = "LarssonMartin1998's dotfiles configured with Home Manager";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }:
    let
        lib = nixpkgs.lib;

        # supportedSystems = [
        #     "x86_64-linux"
        #     "aarch64-linux"
        #     "aarch64-darwin"
        # ];

        makeHomeConfig = {
            name,
            system,
            extraModules ? []
        }:
            home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { inherit system; };
                modules = [
                    ./nix/home.nix
		    ./nix/local_machine.nix
                ] 
                ++ extraModules
                ++ lib.optional (builtins.match ".*-darwin$" system != null) ./nix/darwin.nix
                ++ lib.optional (builtins.match ".*-linux$" system != null) ./nix/linux.nix;
            };
    in {
        homeConfigurations = {
            "wsl" = makeHomeConfig {
                name = "wsl";
                system = "x86_64-linux";
                extraModules = [ ./nix/wsl.nix ];
            };

            "linux-x86" = makeHomeConfig {
                name = "linux-x86";
                system = "x86_64-linux";
            };

            "linux-aarch64" = makeHomeConfig {
                name = "linux-aarch64";
                system = "aarch64-linux";
            };

            "darwin-aarch64" = makeHomeConfig {
                name = "darwin-aarch64";
                system = "aarch64-darwin";
            };
        };
    };
}
