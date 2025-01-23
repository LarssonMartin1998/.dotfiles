{
    description = "LarssonMartin1998's dotfiles configured with Home Manager";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        neovim = {
            url = "github:LarssonMartin1998/neovim-flake";
        };
    };

    outputs =
    {
        nixpkgs,
        home-manager,
        neovim,
        ...
    }:
    let
        lib = nixpkgs.lib;

        makeHomeConfig =
        {
            name,
            system,
            extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit system; };
            modules =
                [
                    ./nix/home.nix
                    ./nix/local_machine.nix
                ]
                ++ extraModules
                ++ lib.optional (builtins.match ".*-darwin$" system != null) ./nix/darwin.nix
                ++ lib.optional (builtins.match ".*-linux$" system != null) ./nix/linux.nix;

            # Pass neovim-flake to all modules
            extraSpecialArgs = {
                neovim-flake = neovim;
            };
        };
    in
    {
        homeConfigurations = {
            "wsl" = makeHomeConfig {
                name = "wsl";
                system = "x86_64-linux";
                extraModules = [ ./nix/wsl.nix ];
            };

            "linux-x86" = makeHomeConfig {
                name = "linux-x86";
                system = "x86_64-linux";
                extraModules = [ ./nix/linux.nix ];
            };

            "linux-aarch64" = makeHomeConfig {
                name = "linux-aarch64";
                system = "aarch64-linux";
                extraModules = [ ./nix/linux.nix ];
            };

            "darwin-aarch64" = makeHomeConfig {
                name = "darwin-aarch64";
                system = "aarch64-darwin";
                extraModules = [ ./nix/darwin.nix ];
            };
        };
    };
}
