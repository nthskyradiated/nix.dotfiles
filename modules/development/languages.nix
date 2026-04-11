{ pkgs, ... }:

{
  home.packages = with pkgs; [

    typescript-language-server
    vscode-langservers-extracted
    gopls
    tofu-ls
    yaml-language-server
    lua-language-server
    pyright
    zls
    svelte-language-server
    bash-language-server
    dockerfile-language-server
    helm-ls
    nil

    prettier
    stylua
    black
    isort
    shfmt
    yamlfmt
    nixpkgs-fmt

    eslint
    hadolint
    ansible-lint
    yamllint
    statix
    pylint
    python313Packages.mypy
    golangci-lint
    luajitPackages.luacheck
    markdownlint-cli
    tflint
    kubeconform

    ripgrep
    fd
    fzf
  ];
}

