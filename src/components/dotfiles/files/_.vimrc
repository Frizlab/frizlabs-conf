let $dynVimRC = expand("~/.vimrc:dyn")
if filereadable($dynVimRC)
	source $dynVimRC
endif

syntax on
set number
set cindent
set tabstop=3

set shiftwidth=0   " Make 'shiftwidth'  follow 'tabstop'
set softtabstop=-1 " Make 'softtabstop' follow 'shiftwidth'

set modeline
set modelines=5

" For Objective-J files
au BufNewFile,BufRead *.j setf objj
