{config, pkgs, ...}: {
	hardware = {
		graphics.enable = true;
		bluetooth = {
			enable = true;
			powerOnBoot = true;
			settings = {
				General = {
					Experimental = true;
				};
				Policy = {
					AutoEnable = true;
				};
			};
		};
	};
	boot.kernelPackages = pkgs.linuxPackages_latest;
	security.rtkit.enable = true;
	networking = {
		networkmanager.enable = true;
		nameservers = [
			"1.1.1.1"
			"9.9.9.9"
		];
	};
	services = {
		greetd = {
			enable = true;
			settings = {
				default_session = {
					command = "${config.programs.niri.package}/bin/niri-session";
					user = "quenia";
				};
			};
		};
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			wireplumber.enable = true;
			jack.enable = true;
		};
		tailscale.enable = true;
		blueman.enable = true;
		udisks2.enable = true;
		openssh = {
			enable = true;
			settings = {
				PermitRootLogin = "prohibit-password";
				PasswordAuthentication = false;
			};
		};
	};
	programs = {
		xwayland.enable = true;
		steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			localNetworkGameTransfers.openFirewall = true;
		};
		niri.enable = true;
		waybar.enable = true;
		appimage = {
			enable = true;
			binfmt = true;
		};
		nix-ld = {
			enable = true;
			libraries = with pkgs; [
				libX11
				libxkbcommon
				libxcb
				libXrender
				libXrandr
				libXinerama
				libinput
				libxcomposite
				libxdamage
				libXext
				libxfixes
				wayland
				wayland-protocols
				mesa
				vulkan-loader
				libglvnd
				fontconfig
				libXcursor
				libdecor
				libpulseaudio
				alsa-lib
				libadwaita
				gtk3
				gtk4
				pango
				cairo
				glib
				bzip2
			];
		};
	};
	fonts = {
		fontconfig.enable = true;
		packages = with pkgs; [
			noto-fonts
			font-awesome_4
			dejavu_fonts
		];
	};
	users.users.quenia = {
		isNormalUser = true;
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6w7VubW0B4SLF2DGCqOeJU3X/6zCpXBYvFraisjyQc queniaVT@proton.me" # dprk-gov-surveillance-device
		];
		extraGroups = ["wheel"];
	};
	home-manager.users.quenia = {
		dconf.settings = {
			"org/gnome/desktop/background" = {
				picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
			};
			"org/gnome/desktop/interface" = {
				color-scheme = "prefer-dark";
			};
		};
	};
	environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
	nixpkgs.config.allowUnfree = true;
	time.timeZone = "Europe/Prague";
	nix.settings.experimental-features = ["nix-command" "flakes"];
	systemd.user.services.niri.enableDefaultPath = false;
	system.stateVersion = "26.05";
}
