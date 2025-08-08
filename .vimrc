" 使用Vundle安装插件
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'wanngsanchao/vim-yaml'
Plugin 'andrewstuart/vim-kubernetes.git'
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'tomasr/molokai'
Plugin 'vim-syntastic/syntastic'
Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'
Plugin 'ycm-core/YouCompleteMe'

call vundle#end()

filetype plugin indent on               "加载vim自带和插件相应的语法和文件类型相关脚本
filetype indent on                      "为特定文件类型载入相关缩进文件
syntax on                               "语法高亮
set nocompatible                        "不要使用vi的键盘模式，而是vim自己的
set vb t_vb=                            "关闭烦人的当当当声音
set tabstop=4                           "设置制表符宽度为4
set softtabstop=4                       "设置软制表符缩进为4
set shiftwidth=4                        "设置缩进的空格数为4
set cindent                             "设置使用C/C++语言的自动缩进方式
set backspace=2                         "解决退格删除不了的问题
set autoindent                          "自动缩进
set smartindent                         "开启新行时使用智能自动缩进
set number                              "显示行号
set ruler                               "显示光标所在位置的行号和列号
set expandtab                           "将tab替换为相应数量空格
set cursorline                          "突出显示当前行
set fileencodings=ucs-bom,utf-8,cp936
set encoding=utf-8                      "设置文件编码统一为UTF-8
set fileencodings=ucs-bom,utf-8,cp936   "设置文件编码统一为UTF-8
autocmd VimEnter * NERDTree | wincmd p  "启动NERDTree并光标另一个窗口

"vim没有文件也启动NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif


" Use homebrew's clangd
let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'

" *************** 自动文件信息头 *****************
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: wsc")
        call append(line(".")+2, "\# mail: 1874417000@qq.com")
        call append(line(".")+3, "\# Created Time: ".strftime("%F %T"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "")
        call append(line(".")+7, "")
    else
        call setline(1, "/*************************************************************************")
        call append(line("."), "    > File Name: ".expand("%"))
        call append(line(".")+1, "    > Author: wsc")
        call append(line(".")+2, "    > Mail: 1874417000@qq.com ")
        call append(line(".")+3, "    > Created Time: ".strftime("%F %T"))
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "")
        call append(line(".")+8, "using namespace std;")
        call append(line(".")+9, "")
        call append(line(".")+10, "int main(int argc, char *argv[])")
        call append(line(".")+11, "{")
        call append(line(".")+12,	"	")
        call append(line(".")+13, "	return 0;")
        call append(line(".")+14, "}")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "#include <stdlib.h>")
        call append(line(".")+8, "#include <string.h>")
        call append(line(".")+9, "")
        call append(line(".")+10, "")
        call append(line(".")+11, "")
    endif
    autocmd BufNewFile * normal G
    if &filetype == 'c' || &filetype == 'cpp'
        autocmd BufNewFile * normal k
        autocmd BufNewFile * normal k
        autocmd BufNewFile * normal k
    endif
endfunc

" 啊,搞不懂,上面的BufNewFile需要再调用一下才正确
autocmd BufNewFile * exec ":call Test()"
func Test()
endfunc

""""""""""syntastic""""""""""""
"c配置
let g:syntastic_c_compiler =['gcc', 'clang', 'make']
let g:syntastic_c_compiler_options ='-Wpedantic -g'
let g:syntastic_c_include_dirs=['/usr/include/','/root/nginx-1.23.4/src/core','/root/nginx-1.23.4/src/event','/root/nginx-1.23.4/src/http','/root/nginx-1.23.4/src/mail','/root/nginx-1.23.4/src/misc','/root/nginx-1.23.4/src/os','/root/nginx-1.23.4/src/stream',"/root/cprojects/include/","/usr/local/include/","/usr/include/libuser/"]
let g:syntastic_c_config_file='.syntastic_c_config_file'


"cpp配置
let g:syntastic_check_on_open = 0

let g:syntastic_cpp_include_dirs = ['/usr/include/']

let g:syntastic_cpp_remove_include_errors = 1

let g:syntastic_cpp_check_header = 1

let g:syntastic_cpp_compiler = 'clang++'

" set error or warning signs

let g:syntastic_error_symbol = "x"

let g:syntastic_warning_symbol = "!"

" whether to show balloons

let g:syntastic_enable_balloons = 1

""""""""""""YCM""""""""""""""""""""

"let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py"
"let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_confirm_extra_conf = 0

let g:ycm_min_num_of_chars_for_completion=1 " 从第一个键入字符就开始罗列匹配项

let g:ycm_key_invoke_completion = '<c-x>'
"配置快捷键
let mapleader= ','
 nnoremap <leader>l :YcmCompleter GoTo<CR> "跳转
 nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR> "跳转到定义或声明
 nnoremap <leader>gt :YcmCompleter GetType<CR> "get类型
 nmap gi :YcmCompleter GoToInclude<CR>   "跳转到include、声明或定义
 nmap gm :YcmCompleter GoToImprecise<CR> "跳转到实现
 nmap gr :YcmCompleter GoToReferences<CR> "跳转到引用
"普通功能快捷键映射 
 nmap <c-s> :w!<CR> "使用Ctrl+s进行保存
 imap <c-s> <Esc>:w!<CR> "使用Ctrl+s进行保存
 nmap <c-q> :qall!<CR> "使用Ctrl+q进行保存
 imap <c-q> :qall!<CR> "使用Ctrl+q进行保存
"使用ctrl+e 来替换shift+$来进行行尾定位
 nmap <c-e> <S-$>
 imap <c-e> <s-$>
 "使用ctrl+a 来替换shift+^来惊醒行首定位
 nmap <c-a> <S-^>
 "使用ctrl+c 来替换yy进行复制
 nmap <c-c> yy
 "使用ctrl+v 来替换p进行黏贴
 nmap <c-v> p
 "使用ctrl+z 来替换u进行撤销
 nmap <c-z> u
 "使用shift+f来替换1G进行首行跳转
 nmap <s-f> 1G
 "使用ctrl+d 来代替dd删除当前行
 nmap <c-d> dd
 "d0 字母d+数字0删除光标到行首的部分
 nmap <c-u> d0
 "d$ 字母d+特殊字符$删除光标到行尾
 nmap <c-j> d$
 "使用tab建，代替shift+>> 进行向右缩进
 nmap <tab> <s->>>
 "使用shift+tab建，代替shift+<< 进行向左缩进
 nmap <s-tab> <s-<><

