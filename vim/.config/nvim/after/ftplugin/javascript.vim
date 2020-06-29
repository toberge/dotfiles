setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

let b:ale_linters = [ 'standard', 'eslint' ]
let b:ale_fixers = [ 'prettier' ]
" let g:ale_javascript_standard_executable = 'semistandard'
