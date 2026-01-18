{
  description = "Andy's Neovim Configuration with nixCats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = { self, nixpkgs, nixCats, ... }:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      extra_pkg_config = {
        allowUnfree = true;
      };

      dependencyOverlays = [ ];

      # Category definitions - what dependencies are available
      categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
        # LSP servers and runtime dependencies
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            # Language servers
            typescript-language-server
            vscode-langservers-extracted
            gopls
            tofu-ls
            pyright
            zls
            svelte-language-server
            bash-language-server
            docker-compose-language-service
            dockerfile-language-server
            nil
            yaml-language-server
            helm-ls
            lua-language-server

            # Formatters
            prettier
            yamlfmt
            black
            isort
            stylua
            shfmt
            nixpkgs-fmt

            # Linters
            golangci-lint
            hadolint
            yamllint
            markdownlint-cli
            pylint
            luajitPackages.luacheck
            statix
            tflint
            kubeconform
            python313Packages.mypy

            # Other tools
            ripgrep
            fd
            fzf
            bat
            tree-sitter
          ];
        };

        startupPlugins = {
          general = with pkgs.vimPlugins; [
            tokyonight-nvim

            plenary-nvim
            nvim-web-devicons

            lualine-nvim
            which-key-nvim
            gitsigns-nvim
            comment-nvim

            nvim-lspconfig
            nvim-cmp
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp-cmdline
            luasnip
            cmp_luasnip

            conform-nvim
            nvim-lint

            telescope-nvim
            telescope-fzf-native-nvim
            harpoon2

            vim-fugitive

            undotree
            zen-mode-nvim

            (nvim-treesitter.withPlugins (p: [
              p.typescript
              p.javascript
              p.tsx
              p.go
              p.terraform
              p.json
              p.yaml
              p.lua
              p.vim
              p.vimdoc
              p.markdown
              p.python
              p.zig
              p.svelte
              p.bash
              p.nix
            ]))
          ];
        };

        optionalPlugins = {
          general = [ ];
        };

        sharedLibraries = {
          general = [ ];
        };

        extraPython3Packages = {
          general = (_: [ ]);
        };

        extraLuaPackages = {
          general = [ (_: [ ]) ];
        };
      };

      packageDefinitions = {
        nvim = { pkgs, ... }: {
          settings = {
            wrapRc = true;
            configDirName = "nixcats-nvim";
            aliases = [ ];
          };
          categories = {
            general = true;
          };
        };
      };

      defaultPackageName = "nvim";
    in
    # Merge all outputs properly
    (forEachSystem (system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath
          {
            inherit nixpkgs system dependencyOverlays extra_pkg_config;
          }
          categoryDefinitions
          packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;
      })) // {
      homeModule = { config, lib, pkgs, ... }: {
        home.packages = [ self.packages.${pkgs.system}.default ];
      };
    };
}
