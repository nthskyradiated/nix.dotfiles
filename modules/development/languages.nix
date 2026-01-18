{ pkgs, ... }:

{
  home.packages = with pkgs; [

    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    gopls
    tofu-ls
    yaml-language-server
    lua-language-server
    pyright
    zls
    svelte-language-server
    nodePackages.bash-language-server
    dockerfile-language-server
    helm-ls
    nil

    nodePackages.prettier
    stylua
    black
    isort
    shfmt
    yamlfmt
    nixpkgs-fmt

    nodePackages.eslint
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

