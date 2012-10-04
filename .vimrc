



set bg=dark
syntax on
set title
set nocompatible
:match ErrorMsg '\%>80v.\+'
"set number "shows line num

" php helpfuls
" let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1
let php_parent_error_open = 1
let php_folding = 1

" some common helpful settings 
set tabstop=4
set shiftwidth=4
set expandtab

"do an incremental search
set incsearch

" Correct indentation after opening a phpdocblock and automatic * on every line
set formatoptions=qroct

" Wrap visual selectiosn with chars
:vnoremap ( "zdi^V(<C-R>z)<ESC>
:vnoremap { "zdi^V{<C-R>z}<ESC>
:vnoremap [ "zdi^V[<C-R>z]<ESC>
:vnoremap ' "zdi'<C-R>z'<ESC>
:vnoremap " "zdi^V"<C-R>z^V"<ESC>

" Detect filetypes
"if exists("did_load_filetypes")
"    finish
"endif
augroup filetypedetect
    au! BufRead,BufNewFile *.pp     setfiletype puppet
    au! BufRead,BufNewFile *httpd*.conf     setfiletype apache
    au! BufRead,BufNewFile *inc     setfiletype php
augroup END

" Nick wrote: Uncomment these lines to do syntax checking when you save
augroup Programming
" clear auto commands for this group
autocmd!
autocmd BufWritePost *.php !php -d display_errors=on -l <afile>
autocmd BufWritePost *.inc !php -d display_errors=on -l <afile>
"autocmd BufWritePost *.C !make "annoying
"autocmd BufWritePost *.h !make "annoying
autocmd BufWritePost *httpd*.conf !/etc/rc.d/init.d/httpd configtest
autocmd BufWritePost *.bash !bash -n <afile>
autocmd BufWritePost *.sh !bash -n <afile>
autocmd BufWritePost *.pl !perl -c <afile>
autocmd BufWritePost *.perl !perl -c <afile>
autocmd BufWritePost *.xml !xmllint --noout <afile>
autocmd BufWritePost *.xsl !xmllint --noout <afile>
autocmd BufWritePost *.js !~/jslint/jsl -conf ~/jslint/jsl.default.conf -nologo -nosummary -process <afile>
autocmd BufWritePost *.rb !ruby -c <afile>
autocmd BufWritePost *.pp !puppet --parseonly <afile>
augroup en

" enable filetype detection:
filetype on

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" my common spelling mistakes ;)
abbreviate wierd weird
abbreviate restaraunt restaurant


"set ls=2            " allways show status line
"set ruler           " show the cursor position all the time

"au BufNewFile,BufRead  *.pls    set syntax=dosini



if &term == "xterm-color"
  fixdel
endif

" Enable folding by fold markers
" this causes vi problems set foldmethod=marker 

" Correct indentation after opening a phpdocblock and automatic * on every
" line
set formatoptions=qroct
set autoindent
set smartindent
" disable auto and smart indenting on demand for pasted text
set pastetoggle=<F2>

" The completion dictionary is provided by Rasmus:
" http://lerdorf.com/funclist.txt
set dictionary-=~/phpfunclist.txt dictionary+=~/phpfunclist.txt
" Use the dictionary completion
set complete-=k complete+=k

" {{{ Autocompletion using the TAB key

" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function InsertTabWrapper()
    let col = col('.') - 1
   if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" Remap the tab key to select action with InsertTabWrapper
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" }}} Autocompletion using the TAB key

" {{{ Mappings for autogeneration of PHP code

" There are 2 versions available of the code templates, one for the case, that
" the close character mapping is disabled and one for the case it is enabled.

" {{{ With close char mapping activated (currently active)

"The following were the only line added by Carl
map! =doc  /* <CR>@name: <CR>@description: <CR>@param: <CR>@return: <CR>*/
" Taglist hotkey
nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F9> :TlistAddFilesRecursive .<CR>
"nnoremap <silent> <F10> :!make | less<CR> " broken, doesn't like shell cmds
" require, require_once
map! =req /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>require '<RIGHT>;<LEFT><Left>
map! =roq /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>require_once '<RIGHT>;<LEFT><Left>

" include, include_once
map! =inc /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>include '<RIGHT>;<Left><Left>
map! =ioc /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>include_once '<Right>;<Left><Left>

" define
map! =def /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>* @access public<CR>*/<CR><LEFT>define ('<Right>, '<Right><Right>;<ESC>?',<CR>i

" class
map! =cla /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>class  {<CR><ESC>?/\*\*<CR>/ \* <CR>$i

" public/private methods
map! =puf /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>* @access public<CR>* @param  <CR>* @return void<CR>*/<CR><LEFT>public function  (<Right><CR>{<CR><ESC>?/\*\*<CR>/ \* <CR>$i
map! =prf /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>* @access private<CR>* @param  <CR>* @return void<CR>*/<CR><LEFT>private function _ (<Right><CR>{<CR><ESC>?/\*\*<CR>/ \* <CR>$i

" public/private attributes
map! =pua /**<CR> *  <CR>*  <CR>* @var <CR>* @since  <CR>*/<CR><LEFT>public $ = ;<ESC>?/\*\*<CR>/ \* <CR>$i
map! =pra /**<CR> *  <CR>*  <CR>* @var <CR>* @since  <CR>*/<CR><LEFT>private $_ = ;<ESC>?/\*\*<CR>/ \* <CR>$i

" for loop
map! =for for ($i = 0; $i ; $i++)<Right> {<CR><CR>}//end for<Up><Up><ESC>/ ;<CR>i

" foreach loop
map! =foe foreach ($ as $ => $ )<Right> {<CR><CR>}//end foreach<Up><xHome><ESC>/\ as<CR>i

" while loop
map! =whi while ( )<Right> {<CR><CR>}//end while<Up><Up><ESC>/ )<CR>i

" switch statement
map! =swi switch ($ )<Right> {<CR>case ''<Right>:<CR><CR>break;<CR>default:<CR><CR>break;<CR>}//end switch<Up><Up><Up><Up><Up><Up><Up><ESC>/)<CR>i

" alternative
map! =if if (<Right> {<Down><xEnd> else {<Up><Up><Up><Up><Up><Up><ESC>/)<CR>i

" }}} With close char mapping activated (currently active)

" {{{ With close char mapping de-activated (currently in-active)

" require, require_once
"map! =req /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>require '';<ESC>hi
"map! =roq /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>require_once '';<ESC>hi

" include, include_once
"map! =inc /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>include '';<ESC>hi
"map! =ioc /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>include_once '';<ESC>hi

" define
"map! =def /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>* @access public<CR>*/<CR><LEFT>define ('', '');<ESC>?',<CR>i

" class
"map! =cla /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>*/<CR><LEFT>class  {<CR><CR>}<CR><ESC>?/\*\*<CR>/ \* <CR>$i

" public/private methods
"map! =puf /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>* @access public<CR>* @param  <CR>* @return void<CR>*/<CR><LEFT>public function  ()<CR>{<CR><CR>}<CR><ESC>?/\*\*<CR>/ \* <CR>$i
"map! =prf /**<CR> *  <CR>*  <CR>*  <CR>* @since  <CR>* @access private<CR>* @param  <CR>* @return void<CR>*/<CR><LEFT>private function _ ()<CR>{<CR><CR>}<CR><ESC>?/\*\*<CR>/ \* <CR>$i

" public/private attributes
"map! =pua /**<CR> *  <CR>*  <CR>* @var <CR>* @since  <CR>*/<CR><LEFT>public $ = ;<ESC>?/\*\*<CR>/ \* <CR>$i
"map! =pra /**<CR> *  <CR>*  <CR>* @var <CR>* @since  <CR>*/<CR><LEFT>private $_ = ;<ESC>?/\*\*<CR>/ \* <CR>$i

" for loop
"map! =for for ($i = 0; $i ; $i++) {<CR><CR>}<Up><Up><ESC>/ ;<CR>i

" foreach loop
"map! =foe foreach ($ as $ => $) {<CR><CR>}<Up>

" while loop
"map! =whi while ( ) {<CR><CR>}<Up><Up><ESC>/ )<CR>i

" switch statement
"map! =swi switch ($) {<CR>case '':<CR><CR>break;<CR>default:<CR><CR>break;<CR>}<Up><Up><Up><Up><Up><Up><Up><ESC>/)<CR>i

" alternative
"map! =if if () {<CR><CR>} else {<CR><CR>}<Up><Up><Up><Up><Up><Up><ESC>/)<CR>i

" }}} With close char mapping de-activated (currently in-active)

" }}} Mappings for autogeneration of PHP code


        fun! EnsureVamIsOnDisk(vam_install_path)
          " windows users may want to use http://mawercer.de/~marc/vam/index.php
          " to fetch VAM, VAM-known-repositories and the listed plugins
          " without having to install curl, 7-zip and git tools first
          " -> BUG [4] (git-less installation)
          let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
          if eval(is_installed_c)
            return 1
          else
            if 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
              " I'm sorry having to add this reminder. Eventually it'll pay off.
              call confirm("Remind yourself that most plugins ship with ".
                          \"documentation (README*, doc/*.txt). It is your ".
                          \"first source of knowledge. If you can't find ".
                          \"the info you're looking for in reasonable ".
                          \"time ask maintainers to improve documentation")
              call mkdir(a:vam_install_path, 'p')
              execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
              " VAM runs helptags automatically when you install or update 
              " plugins
              exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
            endif
            return eval(is_installed_c)
          endif
        endf

        fun! SetupVAM()
          " Set advanced options like this:
          " let g:vim_addon_manager = {}
          " let g:vim_addon_manager['key'] = value

          " Example: drop git sources unless git is in PATH. Same plugins can
          " be installed from www.vim.org. Lookup MergeSources to get more control
          " let g:vim_addon_manager['drop_git_sources'] = !executable('git')
          " let g:vim_addon_manager.debug_activation = 1

          " VAM install location:
          let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
          if !EnsureVamIsOnDisk(vam_install_path)
            echohl ErrorMsg
            echomsg "No VAM found!"
            echohl NONE
            return
          endif
          exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

          " Tell VAM which plugins to fetch & load:

" ADD NEWLY INSTALLED ADDONS HERE
    call vam#ActivateAddons(['taglist', 'vim-twig', 'jslint', 'php-cs-fixer'], {'auto_install' : 0})

           " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

          " Addons are put into vam_install_path/plugin-name directory
          " unless those directories exist. Then they are activated.
          " Activating means adding addon dirs to rtp and do some additional
          " magic

          " How to find addon names?
          " - look up source from pool
          " - (<c-x><c-p> complete plugin names):
          " You can use name rewritings to point to sources:
          "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
          "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
          " Also see section "2.2. names of addons and addon sources" in VAM's documentation
        endfun
        call SetupVAM()
        " experimental [E1]: load plugins lazily depending on filetype, See
        " NOTES
        " experimental [E2]: run after gui has been started (gvim) [3]
        " option1:  au VimEnter * call SetupVAM()
        " option2:  au GUIEnter * call SetupVAM()
        " See BUGS sections below [*]
        " Vim 7.0 users see BUGS section [3]


" ALWAYS do this last as this .vimrc is not necessarily encoded as utf-8
set encoding=utf-8
