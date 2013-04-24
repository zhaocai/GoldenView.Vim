" =============== ============================================================
" Name           : print.vim
" Synopsis       : vim script library: print
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Sat 03 Sep 2011 03:54:00 PM EDT
" Last Modified  : Thu 20 Sep 2012 04:25:11 PM EDT
" Tag            : [ vim, print ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================





" ============================================================================
" Echo Message:                                                           [[[1
" ============================================================================

function! GoldenView#zl#print#echomsg(message, ...)
    "--------- ------------------------------------------------
    " Desc    : echomsg wrapper
    "
    " Args    :
    "  - message to print
    "  - opts : >
    "  {
    "    'hl'  : 'MoreMsg'          ,
    "  }
    " Return  :
    " Raise   :
    "--------- ------------------------------------------------

    if empty(a:message) | return | endif
    let opts = {
        \ 'hl' : 'MoreMsg',
        \ }
    if a:0 >= 1 && type(a:1) == type({})
        call extend(opts, a:1)
    endif

    execute 'echohl ' . opts.hl
    for m in split(a:message, "\n")
        echomsg m
    endfor
    echohl NONE
endfunction

function! GoldenView#zl#print#warning(message)
    call GoldenView#zl#print#echomsg(a:message, {'hl':'WarningMsg'})
endfunction
function! GoldenView#zl#print#error(message)
    call GoldenView#zl#print#echomsg(a:message, {'hl':'ErrorMsg'})
endfunction
function! GoldenView#zl#print#moremsg(message)
    call GoldenView#zl#print#echomsg(a:message, {'hl':'MoreMsg'})
endfunction




" ============================================================================
" Logger:                                                                 [[[1
" ============================================================================
if !has('ruby')
    function! GoldenView#zl#print#log(...)
        echo "GoldenView#zl(log): require vim to be built with +ruby."
    endfunction
else

ruby ($LOAD_PATH << File.join(Vim.evaluate('g:GoldenView_zl_autoload_path'), 'lib')).uniq!

ruby require 'zlogger'

function! GoldenView#zl#print#log(...)
ruby << __RUBY__

args = Vim.evaluate('a:000')
zlogger = ZLogger.new

case args.size
when 0
  return
when 1
  zlogger.info(args[0].ai(:plain => true))
when 2
  zlogger.send(args[0], args[1]).ai(:plain => true)
else
  zlogger.send(args[0], args[1]).ai(:plain => true)
end
__RUBY__

endfunction


endif


" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :


