" we are not using VI
set nocompatible

colorscheme darkblue
syntax on

" mantiene 3 righe fra il cursore e i margini (superiore e inferiore) dello  schermo durante lo scroll verticale
set scrolloff=3

" imposta il titolo della finestra del terminale
set title

" undo persistenti
set undofile

" aggiorna il file swap ogni secondo (utile per showmarks)
set updatetime=1000

" mostra la riga di riepilogo in basso alla finestra
set showcmd

" permette di usare il mouse per spostare il cursore, eseguire la selezione visuale, etc
set mouse=a 

" {{{ ricerca
" ignorecase + smart case: cerca case insensitive, a meno di non utilizzare una ricerca che inizia con la maiuscola
set ignorecase
set smartcase
" evidenzia i risultati della ricerca anche parziali
set hlsearch
set incsearch
" }}}

" line numbers 
set number
" {{{  try to prevent vim from breaking a line when it is considered too long
set textwidth=0
set wrapmargin=0
set formatoptions=crt
set nowrap
" }}}

" {{{ indentazione
" determines how far something shifts when you use >> or <<
set shiftwidth=4
" determines how many spaces your tabs shift text on your screen
set tabstop=4
filetype indent on
" }}}

" Show menu with possible tab completions
set wildmenu

" Make the completion menus readable
highlight Pmenu ctermfg=0 ctermbg=3
highlight PmenuSel ctermfg=0 ctermbg=7

set autoindent
set smartindent

" con vimdiff non vogliamo la sintassi del linguaggio colorata, ma solo le differenze
if &diff
    syntax off
endif

" auto switch to folder where editing file
autocmd BufEnter * cd %:p:h

" non mostra il messaggio di introduzione lanciando vim senza file da aprire
set shortmess=filnxtToOI

set backspace=start,indent,eol

" :Sudow salva un file utilizzando sudo
command! -bar -nargs=0 Sudow   :silent exe "write !sudo tee % >/dev/null"|silent edit!

" {{{ PHP

"autocmd FileType php let php_sql_query=1
"autocmd FileType php let php_htmlInStrings=1


" :make % per controllare la sintassi con l'interprete php
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

" <CTRL X> <CTRL O>
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd InsertLeave * if pumvisible() == 0|pclose|endif " chiude la finestra della preview delle funzioni una volta usciti dall'insert mode

" offline documentation
" pear install doc.php.net/pman
if filereadable ('/usr/bin/pman')
	set keywordprg=pman
endif

" }}}

filetype plugin on

" % funziona anche su keyword if,else,begin,end,etc..
runtime macros/matchit.vim

" Restore cursor position from previous editing session of a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <a-down> mz:m+<cr>`z
nmap <a-up> mz:m-2<cr>`z
vmap <a-down> :m'>+<cr>`<my`>mzgv`yo`z
vmap <a-up> :m'<-2<cr>`>my`<mzgv`yo`z

" Mappa il paste durante la selezione sul registro 0 invece di " (permette di sostituire piu' selezioni con la parola copiata in origine) NOTA: per avere il comportamento originale usare P (shift + p)  (utile per scambiare due parole)
vmap p "0gp

" CTRL+p esegue il paste inserendo uno spazio fra il cursore ed il testo da incollare
noremap <C-p> <Esc>:let @p = " " . @"<CR>"pp

" CTRL+l fixes syntax highlight and then refresh the screen
noremap <C-l> <Esc>:syntax sync fromstart<CR><C-l>
inoremap <C-l> <C-o>:syntax sync fromstart<CR><C-l>

" attiva il folding su {{{ / }}}
set foldmethod=marker
set foldlevel=20 " i fold partono aperti (a meno che non ci siano piu' di venti livelli annidati
set foldcolumn=2

"Plugin manager
"https://github.com/MarcWeber/vim-addon-manager/blob/master/doc/vim-addon-manager.txt
if filereadable ($HOME . '/.vim-addons/vim-addon-manager/README')
	set runtimepath+=~/.vim-addons/vim-addon-manager
	call scriptmanager#Activate(["vim-addon-manager" , "surround", "repeat"])
endif

if filereadable ($HOME . '/.vim/plugin/showmarks.vim')
	"{{{ Showmarks: la colonna dei mark si aggiorna ogni `updatetime` millisecondi
	let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	let g:showmarks_enable = 0
	" For marks a-z
	highlight ShowMarksHLl term=bold ctermbg=LightBlue ctermfg=Blue
	"" For marks A-Z
	"highlight ShowMarksHLu cterm=bold ctermbg=LightRed ctermfg=DarkRed
	"" For multiple marks on the same line.
	"highlight ShowMarksHLm cterm=bold ctermbg=LightGreen ctermfg=DarkGreen

	highlight ShowMarksHLl ctermfg=white ctermbg=black cterm=bold

	let g:showmarks_hlline_lower = 1

	" Bugfix: activation via showmarks_enable doesn't work
	autocmd BufEnter * DoShowMarks
	"}}}
endif


" {{{ URL plugins
" vim-addon-xdebug: http://www.vim.org/scripts/script.php?script_id=3320
" surround: 		http://www.vim.org/scripts/script.php?script_id=1697
" showmarks:		http://www.vim.org/scripts/script.php?script_id=2142
" phpcomplete:		http://www.vim.org/scripts/script.php?script_id=3171
" align:			http://www.vim.org/scripts/script.php?script_id=294
" gundo:			http://www.vim.org/scripts/script.php?script_id=3304
" histwin.vim:		http://www.vim.org/scripts/script.php?script_id=2932
" }}}
