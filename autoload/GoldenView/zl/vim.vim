" =============== ============================================================
" Description    : vim library: vim
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Mon 03 Sep 2012 09:05:14 AM EDT
" Last Modified  : Thu 20 Sep 2012 06:01:48 PM EDT
" Tag            : [ vim, library, debug ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================








" ============================================================================
" Context:                                                                [[[1
" ============================================================================
function! GoldenView#zl#vim#context()
    " -------- - -----------------------------------------------
    "  Desc    : generate context
    "
    "  Example : >
    "            function BeTraced(...)
    "              exec GoldenView#zl#vim#context() | call XXX#Trace(a:000)
    "            endfunction
    "
    "            function XXX#Trace(...)
    "              let context = g:GoldenView_zl_context
    "              "...
    "            endfunction
    "  Refer   :
    " -------- - -----------------------------------------------
    return
    \'try
    \|  throw ""
    \|catch
    \|   let g:GoldenView_zl_context = v:throwpoint
    \|endtry
    \'
endfunction


" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
