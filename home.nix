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
			gcc
			nodejs_22
			rustc
			cargo
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
			};
			profileExtra = ''
			'';
			bashrcExtra = ''
				hyfetch
			'';
		};
		vim = {
			enable = true;
			extraConfig = ''
				set nocompatible
				filetype on
				syntax on
				set number
				set cursorline
				set cursorcolumn
				set shiftwidth=4
				set tabstop=4
				set softtabstop=0 noexpandtab
				set nowrap
				set incsearch
				set ignorecase
				set showmode
				set showmatch
				set hlsearch
				set wildmenu
				set wildmode=list:longest
				set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
				set statusline=
				set statusline+=\ %F\ %M\ %Y\ %R
				set statusline+=%=
				set statusline+=\ row:\ %l\ col:\ %c\ percent:\ %p%%
				set laststatus=2
				if has("autocmd")
					au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
						\| exe "normal! g'\"" | endif
				endif
				set list
				set listchars=tab:>-
				augroup DisableNixFtplugin
					autocmd!
					autocmd FileType nix let b:did_ftplugin = 1
					autocmd FileType rust let b:did_ftplugin = 1
				augroup END
				hi SpecialKey ctermfg=DarkGrey ctermbg=NONE
				hi LineNr ctermfg=darkgreen guifg=darkgreen
				hi CursorLineNr ctermfg=green guifg=green
				'';
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
	};
	home.file = {
		".config/niri/random-wallpaper.sh" = {
			source = ./niri/scripts/random-wallpaper.sh;
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
