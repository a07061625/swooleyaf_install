au BufRead,BufNewFile /etc/nginx/*,/usr/local/tengine/conf/* if &ft == '' | setfiletype nginx | endif
au BufRead,BufNewFile *.py
\ set tabstop=4
\ set softtabstop=4
\ set shiftwidth=4
\ set textwidth=79
\ set expandtab
\ set autoindent
\ set fileformat=unix
