{ config, lib, pkgs, ... }: {
	imports = [
		../../modules/common.nix
		./hardware-configuration.nix
	];
	networking.hostName = "laptop";
	hardware.bluetooth.settings.General.FastConnectable = false;
	boot = {
		loader.grub = {
			enable = true;
			efiSupport = true;
			device = "/dev/sda";
		};
	};
	services.libinput.enable = true;
}
