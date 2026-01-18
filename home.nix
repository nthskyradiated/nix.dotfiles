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
    nixpkgs-fmt
    libnotify
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
      userEmail = userEmail;
      userName = username;
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
        ls = "exa -l --icons";
        k = "kubectl";
        nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#${hostname}";
        nixdelgrub = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
      };
      profileExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      '';
      initExtra = ''
        BOLD="\[\e[1m\]"
        GREEN="\[\e[32m\]"
        CYAN="\[\e[36m\]"
        BLUE="\[\e[34m\]"
        RESET="\[\e[0m\]"
        PS1="''${BOLD}''${BLUE}\u@\h''${GREEN}:''${CYAN}\w''${GREEN}$\n=>''${RESET} "
      '';
    };
  };

  # GTK theming
  gtk = {
    enable = true;
    font = {
      name = "Adwaita";
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
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Qt theming
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
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
  };
}
