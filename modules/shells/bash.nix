{ pkgs, hostname, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = import ./aliases.nix { inherit hostname; };
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

}
