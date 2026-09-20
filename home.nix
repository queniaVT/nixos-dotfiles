{config, pkgs, inputs, hostName, ...}:
let
	hostConfigs = {
		gayming-station = ./niri/hosts/gayming-station.kdl;
		laptop = ./niri/hosts/laptop.kdl;
	};
	hostConfig = hostConfigs.${hostName};
	checkedNiriConfig = pkgs.runCommand "niri-config-${hostName}"
	{
		nativeBuildInputs = [ pkgs.niri ];
	}
	''
		cat \
		${./niri/common.kdl} \
		${hostConfig} \
		> config.kdl
		niri validate --config config.kdl
		cp config.kdl $out
	'';
	waybarConfigs = {
		gayming-station = ./waybar/hosts/gayming-station;
		laptop = ./waybar/hosts/laptop;
	};
in
{
	home = {
		username = "quenia";
		homeDirectory = "/home/quenia";
		stateVersion = "26.05";
		packages = with pkgs; [
			# gui stuffz
			osu-lazer-bin
			audacity
			lmms
			krita
			obs-studio
			nicotine-plus
			kitty
			discord
			inputs.fluxer.packages.${pkgs.stdenv.hostPlatform.system}.fluxer-canary
			strawberry
			inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
			pavucontrol
			libreoffice
			# kde stuffz
			kdePackages.dolphin
			kdePackages.filelight
			kdePackages.okular
			kdePackages.kde-cli-tools
			# desktop stuffz
			mpvpaper
			fuzzel
			dunst
			playerctl
			xwayland-satellite
			# cli stuffz
			cava
			cmatrix
			htop
			btop
			fastfetch
			hyfetch
			mpv
			jq
			wget
			# dev stuffz
			godot_4_7
			gcc
			dotnet-sdk
			omnisharp-roslyn
			nodejs_22
			rustc
			cargo
			nil # nix lsp
			lua-language-server # lua lsp
			rust-analyzer # rust lsp
			vscode-langservers-extracted # html/css lsp
			csharp-ls # c# lsp
			typescript-language-server # js/ts lsp
			# files stuffz
			tree
			zip
			unzip
			flac
			ffmpeg
			libwebp
			p7zip
			# other stuffz
			kdePackages.kio-admin
			qt6Packages.qt6ct
			wine
			winetricks
			appimage-run
			sshfs
		];
		pointerCursor = {
			enable = true;
			gtk.enable = true;
			package = pkgs.catppuccin-cursors.mochaGreen;
			name = "catppuccin-mocha-green-cursors";
			size = 16;
		};
	};
	programs = {
		git = {
			enable = true;
			settings = {
				user = {
					name = "queniaVT";
					email = "queniaVT@proton.me";
				};
				init.defaultBranch = "main";
				pull.rebase = false;
			};
		};
		bash = {
			enable = true;
			shellAliases = {
				nrs = ''sudo nixos-rebuild switch --flake "$HOME/nixos-dotfiles#$(hostname)"'';
				nfu = "cd $HOME/nixos-dotfiles; sudo nix flake update";
			};
			profileExtra = ''
			'';
			bashrcExtra = ''
				hyfetch
			'';
		};
		neovim = {
			enable = true;
			defaultEditor = true;
			plugins = with pkgs.vimPlugins; [
				nvim-lspconfig
				blink-cmp
				friendly-snippets
			];
			initLua = builtins.readFile ./neovim/init.lua;
			viAlias = true;
			vimAlias = true;
		};
	};
	# catpussy thing
	catppuccin = {
		enable = true;
		autoEnable = true;
		flavor = "mocha";
		accent = "green";
	};
	gtk = {
		enable = true;
		theme = {
			package = pkgs.kdePackages.breeze-gtk;
			name = "Breeze-Dark";
		};
		#iconTheme = {
		#	package = pkgs.adwaita-icon-theme;
		#	name = "Adwaita";
		#};
		font = {
			name = "Sans";
			size = 11;
		};
	};
	xdg.configFile = {
		"niri/config.kdl".source = checkedNiriConfig;
		"waybar/config".source = waybarConfigs.${hostName};
		"waybar/style.css".source = ./waybar/style.css;
		"fuzzel/fuzzel.ini".source = ./fuzzel/fuzzel.ini;
	};
	home.file = {
		".config/niri/set-wallpaper.sh" = {
			source = ./niri/scripts/set-wallpaper.sh;
			executable = true;
		};
		".config/niri/reboot.sh" = {
			source = ./niri/scripts/reboot.sh;
			executable = true;
		};
		".config/niri/shutdown.sh" = {
			source = ./niri/scripts/shutdown.sh;
			executable = true;
		};
		".config/niri/special-toggle.sh" = {
			source = ./niri/scripts/special-toggle.sh;
			executable = true;
		};
		".config/niri/start-strawberry.sh" = {
			source = ./niri/scripts/start-strawberry.sh;
			executable = true;
		};
	};
}
