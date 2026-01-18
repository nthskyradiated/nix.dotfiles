''
  " ============================================================================
  " LSP Configuration - Diagnostics Enabled
  " ============================================================================
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_signs_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_highlights_enabled = 1
  let g:lsp_textprop_enabled = 1
  let g:lsp_signs_error = {'text': '✗'}
  let g:lsp_signs_warning = {'text': '⚠'}
  let g:lsp_signs_hint = {'text': '💡'}

  " Virtual text configuration
  let g:lsp_diagnostics_virtual_text_enabled = 1
  let g:lsp_diagnostics_virtual_text_prefix = '◆ '
  let g:lsp_diagnostics_virtual_text_align = 'after'

  " Auto-configure LSP servers
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    
    " LSP keymaps
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> <leader>f :LspDocumentFormat<CR>
  endfunction

  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  " Register LSP servers manually
  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
      \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
      \ 'whitelist': ['typescript', 'javascript', 'javascriptreact', 'typescriptreact'],
      \ })
  endif

  if executable('vscode-eslint-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'eslint',
      \ 'cmd': {server_info->['vscode-eslint-language-server', '--stdio']},
      \ 'allowlist': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
      \ })
  endif

  if executable('gopls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'gopls',
      \ 'cmd': {server_info->['gopls']},
      \ 'allowlist': ['go', 'gomod'],
      \ })
  endif

  if executable('tofu-ls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'tofu-ls',
      \ 'cmd': {server_info->['tofu-ls', 'serve']},
      \ 'allowlist': ['terraform', 'tf'],
      \ })
  endif

  if executable('yaml-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'yaml-language-server',
      \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
      \ 'allowlist': ['yaml', 'yaml.ansible', 'yaml.docker-compose'],
      \ 'workspace_config': {
      \   'yaml': {
      \     'schemaStore': {
      \       'enable': v:true,
      \       'url': 'https://www.schemastore.org/api/json/catalog.json',
      \     },
      \     'schemas': {
      \       'https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json': [
      \         'azure-pipelines.yml',
      \         'azure-pipelines.yaml',
      \         '*.azure-pipelines.yml',
      \         '*.azure-pipelines.yaml',
      \       ],
      \       'https://json.schemastore.org/github-workflow.json': [
      \         '.github/workflows/*.yml',
      \         '.github/workflows/*.yaml',
      \       ],
      \       'https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json': [
      \         'docker-compose*.yml',
      \         'docker-compose*.yaml',
      \         'compose.yml',
      \         'compose.yaml',
      \       ],
      \       'https://json.schemastore.org/chart.json': [
      \         'Chart.yaml',
      \         'Chart.yml',
      \       ],
      \       'https://json.schemastore.org/values.schema.json': [
      \         'values.yaml',
      \         'values.yml',
      \       ],
      \       'https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json': [
      \         '**/playbooks/*.yml',
      \         '**/playbooks/*.yaml',
      \         '**/roles/*.yml',
      \         '**/roles/*.yaml',
      \         '**/tasks/*.yml',
      \         '**/tasks/*.yaml',
      \         '**/handlers/*.yml',
      \         '**/handlers/*.yaml',
      \         '**/vars/*.yml',
      \         '**/vars/*.yaml',
      \         '**/defaults/*.yml',
      \         '**/defaults/*.yaml',
      \         'site.yml',
      \         'site.yaml',
      \         'main.yml',
      \         'main.yaml',
      \         'playbook*.yml',
      \         'playbook*.yaml',
      \         'inventory.yml',
      \         'inventory.yaml',
      \       ],
            \       'kubernetes': [
      \         '*deployment*.yaml',
      \         '*service*.yaml',
      \         '*ingress*.yaml',
      \         '*configmap*.yaml',
      \         '*secret*.yaml',
      \         '*.k8s.yaml',
      \         '*.kubernetes.yaml',
      \       ],
      \     },
      \     'format': {
      \       'enable': v:true,
      \       'singleQuote': v:true,
      \       'bracketSpacing': v:true,
      \       'proseWrap': 'preserve',
      \       'printWidth': 120,
      \     },
      \     'validate': v:true,
      \     'completion': v:true,
      \     'hover': v:true,
      \     'customTags': [
      \       '!vault',
      \       '!encrypted/pkcs1-oaep scalar',
      \     ],
      \   },
      \ },
      \ })
  endif

  if executable('vscode-json-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'json-language-server',
      \ 'cmd': {server_info->['vscode-json-language-server', '--stdio']},
      \ 'allowlist': ['json', 'jsonc'],
      \ })
  endif

  if executable('pyright-langserver')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'pyright',
      \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
      \ 'allowlist': ['python'],
      \ })
  endif

  if executable('zls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'zls',
      \ 'cmd': {server_info->['zls']},
      \ 'allowlist': ['zig'],
      \ })
  endif

  if executable('svelteserver')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'svelte',
      \ 'cmd': {server_info->['svelteserver', '--stdio']},
      \ 'allowlist': ['svelte'],
      \ })
  endif

  if executable('bash-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'bashls',
      \ 'cmd': {server_info->['bash-language-server', 'start']},
      \ 'allowlist': ['sh', 'bash'],
      \ })
  endif

  if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'dockerls',
      \ 'cmd': {server_info->['docker-langserver', '--stdio']},
      \ 'allowlist': ['dockerfile'],
      \ })
  endif

  if executable('helm_ls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'helm_ls',
      \ 'cmd': {server_info->['helm_ls', 'serve']},
      \ 'allowlist': ['helm'],
      \ })
  endif

  if executable('nil')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'nil',
      \ 'cmd': {server_info->['nil']},
      \ 'allowlist': ['nix'],
      \ })
  endif

  " ============================================================================
  " Enhanced YAML Detection with Content Analysis
  " ============================================================================
  function! s:DetectYamlType() abort
    let l:filename = expand('%:t')
    let l:filepath = expand('%:p')
    
    " Azure Pipelines
    if l:filename =~# 'azure-pipelines\.ya\?ml$' ||
     \ l:filename =~# '\.azure-pipelines\.ya\?ml$'
      setfiletype yaml
      echom '🔷 Azure Pipelines detected'
      return
    endif
    
    " GitHub Actions
    if l:filepath =~# '\.github/workflows/'
      setfiletype yaml
      echom '🐙 GitHub Actions detected'
      return
    endif
    
    " Docker Compose
    if l:filename =~# 'docker-compose' ||
     \ l:filename =~# 'compose\.ya\?ml$'
      setfiletype yaml.docker-compose
      echom '🐳 Docker Compose detected'
      return
    endif
    
    " Helm Chart
    if l:filename =~# '^[Cc]hart\.ya\?ml$'
      setfiletype yaml
      echom '⎈ Helm Chart detected'
      return
    endif
    
    " Helm Values or Templates
    if l:filename =~# 'values\.ya\?ml$' ||
     \ l:filepath =~# '/templates/'
      setfiletype yaml
      echom '⎈ Helm detected'
      return
    endif
    
    " Ansible
    if l:filepath =~# '/playbooks/' ||
     \ l:filepath =~# '/roles/' ||
     \ l:filepath =~# '/tasks/' ||
     \ l:filepath =~# '/handlers/' ||
     \ l:filepath =~# '/vars/' ||
     \ l:filepath =~# '/defaults/' ||
     \ l:filename =~# '^site\.ya\?ml$' ||
     \ l:filename =~# '^main\.ya\?ml$' ||
     \ l:filename =~# '^playbook' ||
     \ l:filename =~# 'inventory\.ya\?ml$'
      setfiletype yaml.ansible
      echom '📜 Ansible detected'
      return
    endif
    
    " Kubernetes - check file content for markers
    let l:lines = getline(1, 50)
    for l:line in l:lines
      if l:line =~# 'apiVersion:' ||
       \ l:line =~# 'kind:\s*Deployment' ||
       \ l:line =~# 'kind:\s*Service' ||
       \ l:line =~# 'kind:\s*ConfigMap' ||
       \ l:line =~# 'kind:\s*Pod' ||
       \ l:line =~# 'kind:\s*Ingress' ||
       \ l:line =~# 'kind:\s*StatefulSet' ||
       \ l:line =~# 'kind:\s*DaemonSet' ||
       \ l:line =~# 'kind:\s*Job' ||
       \ l:line =~# 'kind:\s*CronJob' ||
       \ l:line =~# 'kind:\s*Secret' ||
       \ l:line =~# 'kind:\s*Namespace'
        setfiletype yaml
        echom '☸️  Kubernetes detected'
        return
      endif
    endfor
    
    " Check filename patterns for Kubernetes
    if l:filename =~# '\.k8s\.' ||
     \ l:filename =~# '\.kubernetes\.' ||
     \ l:filename =~# '^deployment' ||
     \ l:filename =~# '^service' ||
     \ l:filename =~# '^configmap' ||
     \ l:filename =~# '^secret' ||
     \ l:filename =~# '^ingress' ||
     \ l:filename =~# '^namespace' ||
     \ l:filename =~# '^pod'
      setfiletype yaml
      echom '☸️  Kubernetes detected'
      return
    endif
    
    " Default to generic YAML
    setfiletype yaml
    echom '📄 Generic YAML detected'
  endfunction

  " Auto-detect YAML file types on buffer read/create
  augroup YamlFiletypeDetect
    autocmd!
    autocmd BufRead,BufNewFile *.yaml,*.yml call s:DetectYamlType()
  augroup END

  " ============================================================================
  " Auto-format on save for specific file types
  " ============================================================================
  augroup AutoFormat
    autocmd!
    autocmd BufWritePre *.go :LspDocumentFormatSync
    autocmd BufWritePre *.tf,*.terraform :LspDocumentFormatSync
    autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx :LspDocumentFormatSync
    autocmd BufWritePre *.json,*.yaml,*.yml :LspDocumentFormatSync
    autocmd BufWritePre *.nix :LspDocumentFormatSync
  augroup END
''
