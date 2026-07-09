{ pkgs, ... }:

{
  home.packages = with pkgs; [

    go
    nodejs_24
    pnpm
    deno
    zig
    conventional-changelog-cli
    gcc
    clang-tools
    typescript

    vscode-extensions.denoland.vscode-deno
    astro-language-server
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
    tailwindcss-language-server
    ansible-language-server
    dockerfile-language-server
    docker-compose-language-service
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
    zig-zlint
    statix
    pylint
    python313Packages.mypy
    golangci-lint
    luajitPackages.luacheck
    markdownlint-cli
    tflint
    kubeconform
  ];
}

