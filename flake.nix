{
  description = "LarssonMartin1998's dotfiles configured with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";

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

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-nikitabobko = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      apple-silicon-support,
      home-manager,
      nix-darwin,
      nixos-wsl,
      neovim,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      homebrew-nikitabobko,
      ...
    }:
    let
      lib = nixpkgs.lib;

      get_pkgs =
        { system }:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      makeSystemConfig =
        {
          name,
          system,
          builder,
          extraModules ? [ ],
          specialArgs ? { },
        }:
        let
          pkgs = get_pkgs { inherit system; };
        in
        builder {
          inherit system;
          pkgs = pkgs;
          modules = [
            {
              nix.settings.experimental-features = "nix-command flakes";
              environment.systemPackages = with pkgs; [
                vim
              ];
            }
            ./nix/system/local.nix
          ] ++ extraModules;

          specialArgs = specialArgs;
        };

      makeHomeConfig =
        {
          name,
          system,
          extraModules ? [ ],
        }:
        let
          pkgs = get_pkgs { inherit system; };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./nix/home/default.nix
            ./nix/home/local.nix
          ] ++ extraModules;

          extraSpecialArgs = {
            neovim-flake = neovim;
            nur = nur.legacyPackages.${system};
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
          extraModules = [
            ./nix/system/linux.nix
            ./nix/system/linux_x86.nix
          ];
        };

        "linux-aarch" = makeSystemConfig {
          name = "linux-aarch";
          system = "aarch64-linux";
          builder = lib.nixosSystem;
          extraModules = [
            ./nix/system/linux.nix
            ./nix/system/linux_aarch.nix
          ];
          specialArgs = {
            apple-silicon-support = apple-silicon-support;
          };
        };
      };

      darwinConfigurations =
        let
          makeDarwinSystem =
            {
              name,
              user,
              extraModules ? [ ],
            }:
            makeSystemConfig {
              inherit name;
              system = "aarch64-darwin";
              builder = nix-darwin.lib.darwinSystem;

              extraModules = [
                ./nix/system/darwin.nix
                nix-homebrew.darwinModules.nix-homebrew
                {
                  nix-homebrew = {
                    enable = true;
                    enableRosetta = true;
                    user = user; # pass the user parameter
                    taps = {
                      "homebrew/core" = homebrew-core;
                      "homebrew/cask" = homebrew-cask;
                      "homebrew/bundle" = homebrew-bundle;
                      "nikitabobko/tap" = homebrew-nikitabobko;
                    };
                    mutableTaps = false;
                  };
                }
              ] ++ extraModules;

              specialArgs = {
                self = self;
              };
            };
        in
        {
          darwin = makeDarwinSystem {
            name = "darwin";
            user = "larssonmartin1998-mac";
          };

          darwin_work = makeDarwinSystem {
            name = "darwin_work";
            user = "martin.larsson";
            extraModules = [
              ./nix/system/darwin_work.nix
            ];
          };
        };

      homeConfigurations = {
        "wsl" = makeHomeConfig {
          name = "wsl";
          system = "x86_64-linux";
          extraModules = [ ./nix/home/wsl.nix ];
        };

        "linux-x86" = makeHomeConfig {
          name = "linux-x86";
          system = "x86_64-linux";
          extraModules = [
            ./nix/home/linux.nix
            ./nix/home/linux_x86.nix
          ];
        };

        "linux-aarch" = makeHomeConfig {
          name = "linux-aarch";
          system = "aarch64-linux";
          extraModules = [
            ./nix/home/linux.nix
            ./nix/home/linux_aarch.nix
          ];
        };

        "darwin" = makeHomeConfig {
          name = "darwin";
          system = "aarch64-darwin";
          extraModules = [
            ./nix/home/darwin.nix
            ./nix/home/darwin_personal.nix
          ];
        };

        "darwin_work" = makeHomeConfig {
          name = "work";
          system = "aarch64-darwin";
          extraModules = [
            ./nix/home/darwin.nix
            ./nix/home/darwin_work.nix
          ];
        };
      };
    };
}
