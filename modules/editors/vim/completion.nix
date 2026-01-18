# Vim autocompletion configuration
''
          " ============================================================================
          " Asyncomplete (autocompletion)
          " ============================================================================
          let g:asyncomplete_auto_popup = 1

          inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

      inoremap <expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ UltiSnips#CanExpandSnippet() ? "\<C-r>=UltiSnips#ExpandSnippet()<CR>" :
            \ "\<Tab>"

      inoremap <expr> <S-Tab>
            \ pumvisible() ? "\<C-p>" :
            \ UltiSnips#CanJumpBackwards() ? "\<C-r>=UltiSnips#JumpBackwards()<CR>" :
            \ "\<S-Tab>"


          " UltiSnips configuration
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
        let g:UltiSnipsSnippetDirectories=["UltiSnips"]

    " UltiSnips configuration
    let g:UltiSnipsSnippetDirectories=[
    \      "/home/andy/nixos-dotfiles/modules/development/snippets/yaml-snippets/ansible",
    \      "/home/andy/nixos-dotfiles/modules/development/snippets/yaml-snippets/kubernetes",
    \      "/home/andy/nixos-dotfiles/modules/development/snippets/yaml-snippets/az-pipelines" ]
  " Register UltiSnips as an asyncomplete source
  call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['yaml'],
        \ 'priority': 5,
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))

''
