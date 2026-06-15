{ pkgs, hostname, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = import ./aliases.nix { inherit hostname; };
    loginShellInit = ''
      if test -z "$WAYLAND_DISPLAY"; and test (tty) = "/dev/tty1"
        exec uwsm start hyprland-uwsm.desktop
      end
    '';

    functions = {
      fish_prompt = ''
        set_color --bold blue
        printf "%s@%s" $USER (prompt_hostname)

        set_color green
        printf ":"

        set_color cyan
        printf "%s" (prompt_pwd)

        set_color green
        printf "\$ "

        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
          set branch (git symbolic-ref --short HEAD 2>/dev/null)

          if test -z "$branch"
            set branch (git describe --tags --exact-match 2>/dev/null)
          end

          if test -z "$branch"
            set branch (git rev-parse --short HEAD 2>/dev/null)
          end

          if test -n "$branch"
              if string length -q -- (git status --porcelain 2>/dev/null)
              set_color red
            else
              set_color green
            end

            printf "󰊢 (%s)" $branch
          end
        end

        printf "\n"

        set_color normal
        printf "=> "
      '';
    };
  };
}
