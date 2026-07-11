{ config, pkgs, username, userEmail, nixCats-nvim, ... }:

{
  imports = [
    nixCats-nvim.homeModule
    ./modules/development/languages.nix
    ./modules/editors/vim
    ./modules/shells/bash.nix
    ./modules/shells/fish.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "adwaita";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    QT_FONT_DPI = "96";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    tealdeer
    eza
    bat
    btop
    shellcheck
    neovide
    yt-dlp
    ffmpeg

    kubectl
    kubeseal
    kubernetes-helm
    k9s

    yq
    jq
    ripgrep
    fd
    fzf

    tor-browser
    sshpass
    opentofu
    mkcert
    libnotify

    qt6Packages.qt6ct
    adwaita-qt
    adwaita-qt6
    qadwaitadecorations
    qadwaitadecorations-qt6
    gnome-themes-extra
    papirus-icon-theme
    rose-pine-hyprcursor

    # Custom scripts for nix-search-tv
    (writeShellScriptBin "ns" ''
      export PATH="${lib.makeBinPath [ fzf nix-search-tv ]}:$PATH"
      ${builtins.readFile "${nix-search-tv.src}/nixpkgs.sh"}
    '')
  ];

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 3000;
    };
  };

  services.hyprsunset = {
    enable = true;
    settings = {
      max-gamma = 100;
      profile = [
        {
          time = "7:00";
          identity = true;
        }
        {
          time = "17:00";
          temperature = 4000;
        }
      ];
    };
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          email = userEmail;
          name = username;
        };
      };
      ignores = [
        "node_modules"
        ".env"
        "!.env.example"
        ".svelte-kit"
        "/build"
        "dist/"
      ];
    };

    btop.settings = {
      color_theme = "tokyo-storm";
      theme_background = false;
    };
  };

  # GTK theming
  gtk = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 11;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt theming - simplified approach
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";

  };

  home.file = {
    ".config/hypr/hyprland.lua".source = ./config/hypr/hyprland.lua;
    ".config/hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;
    ".config/hypr/hl.meta.lua".source = ./config/hypr/hl.meta.lua;
    ".config/dolphinrc".source = ./config/dolphin/dolphinrc;
    ".config/wofi".source = ./config/wofi;
    ".config/waybar".source = ./config/waybar;
    ".config/ghostty".source = ./config/ghostty;
    ".config/scripts/toggle-audio.sh" = {
      source = ./config/scripts/toggle-audio.sh;
      executable = true;
    };
    ".config/openvpn/work.ovpn".source =
      config.lib.file.mkOutOfStoreSymlink
        "/home/andy/nix.dotfiles/config/openvpn/work.ovpn";
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };
    desktopEntries.librewolf = {
      name = "LibreWolf";
      exec = "${pkgs.librewolf}/bin/librewolf";
      icon = "librewolf";
    };
    desktopEntries.nvim = {
      name = "Neovim (Terminal)";
      exec = "ghostty -e nvim";
      icon = "nvim";
      categories = [ "Utility" "Development" ];
    };

    desktopEntries.btop = {
      name = "btop";
      exec = "ghostty -e btop";
      categories = [ "System" "Monitor" ];
    };

    desktopEntries.vim = {
      name = "Vim";
      exec = "vim";
      noDisplay = true;
    };
  };
}
