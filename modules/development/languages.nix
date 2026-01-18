# Shared language servers, formatters, and development tools
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # LSP Servers
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
    gopls
    tofu-ls
    yaml-language-server
    lua-language-server
    pyright # Python LSP
    zls # Zig LSP
    svelte-language-server
    nodePackages.bash-language-server
    dockerfile-language-server # Dockerfile LSP
    helm-ls # Kubernetes Helm LSP
    nil # Nix LSP

    # Formatters
    nodePackages.prettier
    stylua
    black # Python formatter
    isort # Python import sorter
    shfmt # Bash formatter
    yamlfmt # YAML formatter
    nixpkgs-fmt # Nix formatter

    # Linters
    nodePackages.eslint
    hadolint # Dockerfile linter
    ansible-lint
    yamllint
    statix # Nix linter
    pylint # Python linter (NEW)
    python313Packages.mypy # Python type checker (NEW)
    golangci-lint # Go comprehensive linter (NEW)
    luajitPackages.luacheck # Lua linter (NEW)
    markdownlint-cli # Markdown linter (NEW)
    tflint # Terraform linter (NEW)
    kubeconform # kubernetes schemaa validator

    # Search and navigation tools
    ripgrep
    fd
    fzf
    bat
  ];
}

