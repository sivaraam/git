" ~/.vimrc (or drop in your project as .vim/vimrc)
" Tuned for git project C coding guidelines:
" https://git-scm.com/docs/CodingGuidelines
set encoding=utf-8
scriptencoding utf-8

" ── Indentation ──────────────────────────────────────────────────────────────
" "We use tabs to indent, and interpret tabs as taking up to 8 spaces."
set noexpandtab          " keep real tab characters
set tabstop=8            " display tabs as 8 spaces
set shiftwidth=8         " >> / << shift by 8
set softtabstop=0        " no mixed-mode tab/space insertion

" ── Line length ──────────────────────────────────────────────────────────────
" "We try to keep to at most 80 characters per line."
set textwidth=80
set colorcolumn=81       " visual ruler one past the limit
highlight ColorColumn ctermbg=darkgrey guibg=#3a3a3a

" ── Trailing whitespace ──────────────────────────────────────────────────────
" Git patches are unforgiving about trailing whitespace.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" ── C-specific settings ───────────────────────────────────────────────────────
autocmd FileType c,h setlocal cindent        " C-aware indenting
autocmd FileType c,h setlocal cinoptions=
    \:0,             " case labels flush with switch
    \l1,             " align with case label, not with {
    \t0,             " function return type not indented
    \(0,             " align inside unclosed parentheses
    \u0,             " same for nested parens
    \)20,            " search 20 lines for unclosed paren
    \*30             " search 30 lines for unclosed comment

" ── Preprocessor indent ───────────────────────────────────────────────────────
" "#if FOO\n# include <foo.h>\n# if BAR\n#  include..."
" cindent handles # lines; this keeps nested #if indented by 1 space/level.
set cinkeys=0{,0},0),:,0#,!^F,o,O,e

" ── Pointer alignment helper ─────────────────────────────────────────────────
" "char *string" not "char* string" — no auto-fix, but a reminder in statusline.
" (There's no native Vim option for this; clang-format handles enforcement.)

" ── Show invisible characters ────────────────────────────────────────────────
" Makes stray spaces inside indentation immediately visible.
set list
set listchars=tab:»\ ,trail:·,extends:>,precedes:<

" ── Search ───────────────────────────────────────────────────────────────────
set hlsearch
set incsearch
set smartcase
set ignorecase

" ── Statusline: show col so you notice when you hit 80 ───────────────────────
set ruler
set laststatus=2
set statusline=%f\ %h%m%r%=%c,%l/%L\ %P

" ── File hygiene ─────────────────────────────────────────────────────────────
set nobackup
set noswapfile           " avoids swap files in the repo tree (don't .gitignore them)
set encoding=utf-8
set fileformats=unix,dos " prefer LF line endings

" ── Spell-check commit messages and documentation ────────────────────────────
autocmd FileType gitcommit setlocal spell spelllang=en
autocmd BufRead,BufNewFile *.adoc setlocal spell spelllang=en

" ── Quickfix / git grep integration (pairs with contrib/git-jump) ────────────
" :make runs `make` and populates the quickfix list with compiler warnings.
" With DEVELOPER=1 this catches -Werror=unused-parameter etc.
set errorformat=%f:%l:%c:\ %t%*[^:]:\ %m,%f:%l:\ %t%*[^:]:\ %m
command! -nargs=* Ggrep execute 'silent grep! -n <args>' | copen

" ── Filetype detection ───────────────────────────────────────────────────────
filetype plugin indent on
syntax on
