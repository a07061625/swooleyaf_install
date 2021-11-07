# nginx.vim
1. 下载地址 http://www.vim.org/scripts/script.php?script_id=1886
2. 将nginx.vim移动到/usr/share/vim/vim73/syntax(全局) 或 ~/.vim/syntax(个人)
3. 在/usr/share/vim/vim73/filetype.vim(全局) 或 ~/.vim/filetype.vim(个人) 新增如下内容
   ```au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/,/usr/local/tengine/conf/* if &ft == '' | setfiletype nginx | endif```
4. 格式化nginx配置直接用vim打开对应的文件,然后在命令行模式下输入```gg=G```,不用加:
