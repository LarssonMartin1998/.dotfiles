{
  description = "LarssonMartin1998's dotfiles configured with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    neovim.url = "github:LarssonMartin1998/neovim-flake";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nixos-wsl,
      neovim,
      nix-homebrew,
      ...
    }:
    let
      lib = nixpkgs.lib;

      makeSystemConfig =
        {
          name,
          system,
          builder,
          extraModules ? [ ],
          specialArgs ? { },
        }:
        builder {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          modules = [
            {
              nix.settings.experimental-features = "nix-command flakes";
            }
            ./nix/local_system.nix
          ] ++ extraModules;

          specialArgs = specialArgs;
        };

      makeHomeConfig =
        {
          name,
          system,
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          modules = [
            ./nix/pkgs/home.nix
            ./nix/local_home.nix
          ] ++ extraModules;

          # Pass neovim-flake to all modules
          extraSpecialArgs = {
            neovim-flake = neovim;
          };
        };
    in
    {
      nixosConfigurations = {
        "wsl" = makeSystemConfig {
          name = "wsl";
          system = "x86_64-linux";
          builder = lib.nixosSystem;
          extraModules = [ ./nix/system/wsl.nix ];
          specialArgs = {
            nixos-wsl = nixos-wsl;
          };
        };

        "linux-x86" = makeSystemConfig {
          name = "linux-x86";
          system = "x86_64-linux";
          builder = lib.nixosSystem;
          extraModules = [ ./nix/system/linux.nix ];
        };

        "linux-aarch" = makeSystemConfig {
          name = "linux-aarch";
          system = "aarch64-linux";
          builder = lib.nixosSystem;
          extraModules = [ ./nix/system/linux.nix ];
        };
      };

      darwinConfigurations =
        let
          baseDarwinConfig = makeSystemConfig {
            name = "darwin";
            system = "aarch64-darwin";
            builder = nix-darwin.lib.darwinSystem;
            extraModules = [
              ./nix/system/darwin.nix
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                };
              }
            ];
            specialArgs = {
              self = self;
              nix-homebrew = nix-homebrew;
            };
          };
        in
        {
          "darwin" = baseDarwinConfig;
          "darwin_work" = baseDarwinConfig;
        };

      homeConfigurations = {
        "wsl" = makeHomeConfig {
          name = "wsl";
          system = "x86_64-linux";
          extraModules = [ ./nix/pkgs/wsl.nix ];
        };

        "linux-x86" = makeHomeConfig {
          name = "linux-x86";
          system = "x86_64-linux";
          extraModules = [ ./nix/pkgs/linux.nix ];
        };

        "linux-aarch" = makeHomeConfig {
          name = "linux-aarch";
          system = "aarch64-linux";
          extraModules = [ ./nix/pkgs/linux.nix ];
        };

        "darwin" = makeHomeConfig {
          name = "darwin";
          system = "aarch64-darwin";
          extraModules = [ ./nix/pkgs/darwin.nix ];
        };

        "darwin_work" = makeHomeConfig {
          name = "work";
          system = "aarch64-darwin";
          extraModules = [
            ./nix/pkgs/darwin.nix
            ./nix/pkgs/darwin_work.nix
          ];
        };
      };
    };
}
