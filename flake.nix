{
	description = "the flake idk";
	inputs = {nixpkgs = {url = "github:NixOS/nixpkgs/nixos-unstable";};
		catppuccin = {url = "github:catppuccin/nix";
			inputs.nixpkgs.follows = "nixpkgs";};
		zen-browser = {url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";};
		fluxer = {url = "github:Hy4ri/fluxer-flake";
			inputs.nixpkgs.follows = "nixpkgs";};
		aagl = {url = "github:ezKEa/aagl-gtk-on-nix";
			inputs.nixpkgs.follows = "nixpkgs";};
		home-manager = {url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";};};
	outputs = {self, nixpkgs, catppuccin, zen-browser, fluxer, aagl, home-manager, ...}@inputs:
		let
			system = "x86_64-linux";
			commonModules = [
				catppuccin.nixosModules.catppuccin
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.quenia.imports = [
							./home.nix
							catppuccin.homeModules.catppuccin
						];
						backupFileExtension = "backup";
						extraSpecialArgs = {
							inherit inputs;
						};
					};
					imports = [
						aagl.nixosModules.default
					];
					nix.settings = aagl.nixConfig;
					programs = {
						anime-game-launcher.enable = true;
						anime-games-launcher.enable = false;
						honkers-railway-launcher.enable = false;
						honkers-launcher.enable = false;
						wavey-launcher.enable = false;
						sleepy-launcher.enable = false;
					};
				}
			];
			makeHost = hostConfiguration:
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = {
						inherit inputs;
					};
					modules = [
						hostConfiguration
					] ++ commonModules;
				};
		in
		{
			nixosConfigurations = {
				gayming-station = makeHost ./hosts/gayming-station/configuration.nix;
				laptop = makeHost ./hosts/laptop/configuration.nix;
			};
		};
}
