au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/,/usr/local/tengine/conf/* if &ft == '' | setfiletype nginx | endif
