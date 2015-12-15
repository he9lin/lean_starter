map <Leader>o :call VimuxRunCommand("mix test " . bufname("%") . ":" . line("."))<CR>
map <Leader>m :call VimuxRunCommand("mix test " . bufname("%"))<CR>
map <Leader>n :call VimuxRunCommand("mix test")<CR>

let g:agprg='ag -S --nocolor --nogroup --column --ignore _build --ignore node_modules --ignore deps'

