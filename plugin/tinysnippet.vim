if exists('g:vim_tiny_snippet_loaded')
    finish
endif
let g:vim_tiny_snippet_loaded = 1

let g:tiny_snippet_snippet_directories_default = [
            \ fnamemodify(expand('<sfile>:p:h') . '/../snippets', ':p') ]

