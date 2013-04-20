" =============== ============================================================
" Name           : log.vim
" Synopsis       : vim script library: log
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Sat 03 Sep 2011 03:54:00 PM EDT
" Last Modified  : Thu 20 Sep 2012 04:25:11 PM EDT
" Tag            : [ vim, log ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================






" ============================================================================
" Logger:                                                                 [[[1
" ============================================================================
if !has('ruby')
    function! GoldenView#zl#log#info(message)
        echo "GoldenView#zl(log): require vim to be built with ruby support."
    endfunction
else


function! GoldenView#zl#log#info(message)
ruby << __RUBY__
   ($LOAD_PATH << File.join(Vim.evaluate('g:GoldenView_zl_autoload_path'), 'lib')).uniq! 

    require 'zlogger'
    zlogger = ZLogger.new
    zlogger.info Vim::evaluate('a:message')
__RUBY__
endfunction


call GoldenView#zl#rc#init()
endif


" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :


