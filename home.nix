{ config, pkgs, username, userEmail, hostname, nixCats-nvim, ... }:
{
  imports = [
    nixCats-nvim.homeModule
    ./modules/development/languages.nix
    ./modules/editors/vim
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

    go
    nodejs_24
    pnpm
    deno
    conventional-changelog-cli

    kubectl
    kubeseal
    kubernetes-helm
    k9s

    yq
    jq

    tor-browser
    sshpass
    opentofu
    nil
    mkcert
    libnotify

    qt6Packages.qt6ct
    adwaita-qt
    adwaita-qt6
    qadwaitadecorations
    qadwaitadecorations-qt6
    gnome-themes-extra
    papirus-icon-theme

    # Custom scripts for nix-search-tv
    (writeShellScriptBin "ns" ''
      export PATH="${lib.makeBinPath [ fzf nix-search-tv ]}:$PATH"
      ${builtins.readFile "${nix-search-tv.src}/nixpkgs.sh"}
    '')
  ];

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

    bash = {
      enable = true;
      shellAliases = {
        cat = "bat";
        ls = "eza -l --icons";
        k = "kubectl";
        nrs = "sudo nixos-rebuild switch --flake ~/nix.dotfiles#${hostname}";
        nixdelgrub = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
      };
      profileExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      '';
      initExtra = ''
              BOLD="\[\e[1m\]"
              RED="\[\e[31m\]"
              GREEN="\[\e[32m\]"
              CYAN="\[\e[36m\]"
              BLUE="\[\e[34m\]"
              RESET="\[\e[0m\]"

          git_info() {
          git rev-parse --is-inside-work-tree &>/dev/null || return

          branch=$(git symbolic-ref --short HEAD 2>/dev/null \
            || git describe --tags --exact-match 2>/dev/null \
            || git rev-parse --short HEAD 2>/dev/null)

          if git status --porcelain 2>/dev/null | grep -q .; then
            glyph_color="$RED"
          else
            glyph_color="$GREEN"
          fi

          echo -n "''${BOLD}''${glyph_color}󰊢 (''${branch}) "
        }

        build_ps1() {
            PS1="''${BOLD}''${BLUE}\u@\h''${GREEN}:''${CYAN}\w''${GREEN}$ ''$(git_info)\n=>''${RESET} "
        }

        PROMPT_COMMAND=build_ps1
      '';
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  home.file = {
    ".config/hypr".source = ./config/hypr;
    ".config/dolphinrc".source = ./config/dolphin/dolphinrc;
    ".config/wofi".source = ./config/wofi;
    ".config/waybar".source = ./config/waybar;
    ".config/ghostty".source = ./config/ghostty;
    ".config/hypr/scripts/toggle-audio.sh" = {
      source = ./config/hypr/scripts/toggle-audio.sh;
      executable = true;
    };
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
    };

    desktopEntries.gvim = {
      name = "GVim";
      exec = "ghostty -e gvim %F";
      categories = [ "Development" "TextEditor" ];
    };

    desktopEntries.btop = {
      name = "btop";
      exec = "ghostty -e btop";
      categories = [ "System" "Monitor" ];
    };

  };
}
