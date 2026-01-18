# Neovim LSP configuration
''
    -- LSP Configuration
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Helper function to detect YAML type
  local function detect_yaml_type(filepath, filename)
    -- Azure Pipelines
    if filename:match("azure%-pipelines%.ya?ml$") or 
       filename:match("%.azure%-pipelines%.ya?ml$") then
      return "azure-pipelines"
    end
  
    -- GitHub Actions
    if filepath:match("%.github/workflows/") then
      return "github-workflow"
    end
  
    -- Docker Compose
    if filename:match("docker%-compose") or 
       filename:match("compose%.ya?ml$") then
      return "docker-compose"
    end
  
    -- Helm Chart
    if filename:match("^[Cc]hart%.ya?ml$") then
      return "helm-chart"
    end
  
    -- Helm Values
    if filename:match("values%.ya?ml$") or 
       filepath:match("/templates/") then
      return "helm"
    end
  
    -- Ansible - check directory structure and filenames
    if filepath:match("/playbooks/") or
       filepath:match("/roles/") or
       filepath:match("/tasks/") or
       filepath:match("/handlers/") or
       filepath:match("/vars/") or
       filepath:match("/defaults/") or
       filename:match("^site%.ya?ml$") or
       filename:match("^main%.ya?ml$") or
       filename:match("^playbook") or
       filename:match("inventory%.ya?ml$") then
      return "ansible"
    end
  
    -- Kubernetes - check for apiVersion in file content
    local file = io.open(filepath, "r")
    if file then
      local content = file:read("*a")
      file:close()
    
      -- Check for Kubernetes markers
      if content:match("apiVersion:") or
         content:match("kind:%s*Deployment") or
         content:match("kind:%s*Service") or
         content:match("kind:%s*ConfigMap") or
         content:match("kind:%s*Pod") or
         content:match("kind:%s*Ingress") then
        return "kubernetes"
      end
    end
  
    -- Default to generic YAML
    return "yaml"
  end

    -- Keymaps for LSP
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          require('conform').format({ async = true, lsp_fallback = true })
        end, opts)
      end,
    })

    -- LSP servers using new vim.lsp.config API
    vim.lsp.config('ts_ls', {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
      capabilities = capabilities,
    })

    vim.lsp.config('eslint', {
      cmd = { 'vscode-eslint-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' },
      root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'package.json' },
      capabilities = capabilities,
    })

    vim.lsp.config('gopls', {
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })

    vim.lsp.config('tofu-ls', {
      cmd = { 'tofu-ls', 'serve' },
      filetypes = { 'terraform', 'tf' },
      root_markers = { '.terraform', '.git' },
      capabilities = capabilities,
    })

    vim.lsp.config('jsonls', {
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      capabilities = capabilities,
    })

    vim.lsp.config('pyright', {
      cmd = { 'pyright-langserver', '--stdio' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' },
      capabilities = capabilities,
    })

    vim.lsp.config('zls', {
      cmd = { 'zls' },
      filetypes = { 'zig', 'zir' },
      root_markers = { 'zls.json', '.git' },
      capabilities = capabilities,
    })

    vim.lsp.config('svelte', {
      cmd = { 'svelteserver', '--stdio' },
      filetypes = { 'svelte' },
      root_markers = { 'package.json', 'svelte.config.js' },
      capabilities = capabilities,
    })

    vim.lsp.config('bashls', {
      cmd = { 'bash-language-server', 'start' },
      filetypes = { 'sh', 'bash' },
      capabilities = capabilities,
    })

    vim.lsp.config('dockerls', {
      cmd = { 'docker-langserver', '--stdio' },
      filetypes = { 'dockerfile' },
      root_markers = { 'Dockerfile' },
      capabilities = capabilities,
    })

    vim.lsp.config('nil_ls', {
      cmd = { 'nil' },
      filetypes = { 'nix' },
      root_markers = { 'flake.nix', 'flake.lock', '.git' },
      capabilities = capabilities,
      settings = {
        ['nil'] = {
          formatting = {
            command = { "nixpkgs-fmt" },
          },
        },
      },
    })

  vim.lsp.config('yamlls', {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.ansible' },
    capabilities = capabilities,
    settings = {
      yaml = {
        -- Disable default schemas - we'll set them per-file
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
          -- Azure Pipelines
          ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
            "azure-pipelines.yml",
            "azure-pipelines.yaml",
            "*.azure-pipelines.yml",
            "*.azure-pipelines.yaml",
          },
        
          -- GitHub Actions
          ["https://json.schemastore.org/github-workflow.json"] = {
            ".github/workflows/*.yml",
            ".github/workflows/*.yaml",
          },
        
          -- Docker Compose
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
            "docker-compose*.yml",
            "docker-compose*.yaml",
            "compose.yml",
            "compose.yaml",
          },
        
          -- Helm
          ["https://json.schemastore.org/chart.json"] = {
            "Chart.yaml",
            "Chart.yml",
          },
          ["https://json.schemastore.org/values.schema.json"] = {
            "values.yaml",
            "values.yml",
          },
        
          -- Ansible
          ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json"] = {
            "**/playbooks/*.yml",
            "**/playbooks/*.yaml",
            "**/roles/*.yml",
            "**/roles/*.yaml",
            "**/tasks/*.yml",
            "**/tasks/*.yaml",
            "**/handlers/*.yml",
            "**/handlers/*.yaml",
            "site.yml",
            "site.yaml",
            "main.yml",
            "main.yaml",
            "playbook*.yml",
            "playbook*.yaml",
          },
        
          -- Kubernetes - be more selective to avoid false positives
          kubernetes = {
          "*deployment*.yaml",
          "*service*.yaml",
          "*ingress*.yaml",
          "*configmap*.yaml",
          "*secret*.yaml",
          "*.k8s.yaml",
          "*.kubernetes.yaml",
        },
        },
      
        format = {
          enable = true,
          singleQuote = true,
          bracketSpacing = true,
          proseWrap = "preserve",
          printWidth = 120,
        },
      
        validate = true,
        completion = true,
        hover = true,
      
        -- Custom tags for Ansible
        customTags = {
          "!vault",
          "!encrypted/pkcs1-oaep scalar",
        },
      },
    },
  
    -- Override schema per buffer based on detection
    on_new_config = function(config, root_dir)
      local bufname = vim.api.nvim_buf_get_name(0)
      local filename = vim.fn.fnamemodify(bufname, ":t")
      local yaml_type = detect_yaml_type(bufname, filename)
    
      -- Adjust schema based on detected type
      if yaml_type == "ansible" then
        config.settings.yaml.schemas = {
          ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json"] = "*.yaml",
        }
      elseif yaml_type == "kubernetes" then
        config.settings.yaml.schemas = {
          kubernetes = "*.yaml",
        }
      elseif yaml_type == "azure-pipelines" then
        config.settings.yaml.schemas = {
          ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "*.yaml",
        }
      elseif yaml_type == "github-workflow" then
        config.settings.yaml.schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "*.yaml",
        }
      elseif yaml_type == "docker-compose" then
        config.settings.yaml.schemas = {
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*.yaml",
        }
      end
    end,
  })

    -- Enable LSP servers
    vim.lsp.enable({ 
      'helm_ls',
      'ts_ls', 
      'eslint',
      'gopls', 
      'tofu-ls', 
      'jsonls', 
      'yamlls',
      'pyright',
      'zls',
      'svelte',
      'bashls',
      'dockerls',
      'nil_ls'
    })

  -- Smart filetype detection autocmd
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = { "*.yaml", "*.yml" },
    callback = function()
      local filepath = vim.fn.expand("%:p")
      local filename = vim.fn.expand("%:t")
      local yaml_type = detect_yaml_type(filepath, filename)
    
      -- Set filetype
      if yaml_type == "docker-compose" then
        vim.bo.filetype = "yaml.docker-compose"
        print("🐳 Docker Compose detected")
      elseif yaml_type == "ansible" then
        vim.bo.filetype = "yaml.ansible"
        print("📜 Ansible detected")
      elseif yaml_type == "helm" or yaml_type == "helm-chart" then
        vim.bo.filetype = "yaml"
        print("⎈ Helm detected")
      elseif yaml_type == "kubernetes" then
        vim.bo.filetype = "yaml"
        print("☸️  Kubernetes detected")
      elseif yaml_type == "azure-pipelines" then
        vim.bo.filetype = "yaml"
        print("🔷 Azure Pipelines detected")
      elseif yaml_type == "github-workflow" then
        vim.bo.filetype = "yaml"
        print("🐙 GitHub Actions detected")
      else
        vim.bo.filetype = "yaml"
        print("📄 Generic YAML detected")
      end
    
      -- Restart LSP to apply new schema
      vim.defer_fn(function()
        vim.cmd('LspRestart yamlls')
      end, 100)
    end,
  })

    -- Configure conform.nvim for formatting
    require('conform').setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "yamlfmt" },
        ["yaml.ansible"] = { "yamlfmt" },
        ["yaml.docker-compose"] = { "yamlfmt" },
        markdown = { "prettier" },
        go = { "gofmt" },  -- Changed: removed gopls, kept gofmt
        python = { "isort", "black" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        terraform = { "tofu_fmt" },
        -- Removed: dockerfile line (hadolint is a linter, not a formatter)
        nix = { "nixpkgs_fmt" },  -- Changed: underscore instead of hyphen
      },
      formatters = {
        -- Explicitly define nixpkgs-fmt formatter
        nixpkgs_fmt = {
          command = "nixpkgs-fmt",
          args = {},
          stdin = true,
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    -- Command to manually change YAML schema
  vim.api.nvim_create_user_command('YamlSchema', function(opts)
    local schema_type = opts.args
    local schemas = {
      kubernetes = {
        kubernetes = "*.yaml",
      },
      ansible = {
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json"] = "*.yaml",
      },
      docker = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*.yaml",
      },
      azure = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "*.yaml",
      },
      github = {
        ["https://json.schemastore.org/github-workflow.json"] = "*.yaml",
      },
      helm = {
        ["https://json.schemastore.org/chart.json"] = "*.yaml",
      },
    }
  
    if schemas[schema_type] then
      vim.lsp.buf_notify(0, "yaml/schema/store", {
        schemas = schemas[schema_type]
      })
      print("✓ YAML schema changed to: " .. schema_type)
      vim.cmd('LspRestart yamlls')
    else
      print("❌ Unknown schema. Available: kubernetes, ansible, docker, azure, github, helm")
    end
  end, {
    nargs = 1,
    complete = function()
      return { "kubernetes", "ansible", "docker", "azure", "github", "helm" }
    end,
    desc = "Change YAML schema for current buffer"
  })

  -- Keymap to quickly change schema
  vim.keymap.set('n', '<leader>ys', ':YamlSchema ', { desc = 'Change YAML schema' })
''

