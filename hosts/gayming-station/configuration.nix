{ config, lib, pkgs, ... }: {
	imports = [
		../../modules/common.nix
		./hardware-configuration.nix
	];
	networking.hostName = "gayming-station";
	hardware.bluetooth.settings.General.FastConnectable = true;
	boot = {
		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};
	users.extraGroups.vboxusers.members = ["quenia"];
	virtualisation.virtualbox.host.enable = true;
}
