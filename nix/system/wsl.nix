{ nixos-wsl, ... }: {
    imports = [
	nixosWSL.nixosModules.default
    ];

    wsl.enable = true;   
}
