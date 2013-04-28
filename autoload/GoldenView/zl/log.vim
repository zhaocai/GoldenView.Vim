" =============== ============================================================
" Name           : log.vim
" Synopsis       : vim script library: log
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Sat 03 Sep 2012 03:54:00 PM EDT
" Last Modified  : Sat 27 Apr 2013 06:58:13 PM EDT
" Tag            : [ vim, log ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================







" ============================================================================
" Logger:                                                                 [[[1
" ============================================================================


if !has('ruby')

    function! GoldenView#zl#log#info(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
    function! GoldenView#zl#log#level_info(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
            

    function! GoldenView#zl#log#debug(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
    function! GoldenView#zl#log#level_debug(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
            

    function! GoldenView#zl#log#warn(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
    function! GoldenView#zl#log#level_warn(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
            

    function! GoldenView#zl#log#error(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
    function! GoldenView#zl#log#level_error(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
            

    function! GoldenView#zl#log#fatal(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
    function! GoldenView#zl#log#level_fatal(...)
        call GoldenView#zl#print#warning("GoldenView(log): require vim to be built with +ruby.")
    endfunction
            

else


function! <SID>get_logfile()
    if GoldenView#zl#sys#is_mac()
        let logfile = expand('~/Library/Logs/vim/GoldenView.log')
    elseif GoldenView#zl#sys#is_win()
        let logfile = "C:/windows/temp/vim/GoldenView.log" 
    elseif GoldenView#zl#sys#is_linux()
        let logfile = expand('/var/log/vim/GoldenView.log')
    else
        let logfile = input('Please Input logfile: ', '/var/log/vim/GoldenView.log', 'file')
    endif
    let log_dir = fnamemodify(logfile, ':p:h') 
    if !isdirectory(log_dir)
        call mkdir(log_dir, 'p')
    endif
    return logfile
endfunction

let s:GoldenView_zl_ruby_loaded = 0
function! <SID>setup_ruby()
    if s:GoldenView_zl_ruby_loaded == 0

        let logfile = <SID>get_logfile()

        ruby << __RUBY__
# ($LOAD_PATH << File.join(Vim.evaluate('g:GoldenView_zl_autoload_path'), 'lib')).uniq!
require "logger"
require "awesome_print"

$GoldenView_zl_logger = Logger.new(Vim.evaluate('logfile'), 'weekly')
__RUBY__

        autocmd VimLeavePre * call <SID>cleanup_ruby()
        let s:GoldenView_zl_ruby_loaded = 1
    endif
endfunction

function! <SID>cleanup_ruby()
    if s:GoldenView_zl_ruby_loaded
        ruby $GoldenView_zl_logger.close
    endif
endfunction


" --------------------------------%>--------------------------------
" Example:
"   function! Trace(...) abort
"     let message = {}
"     let message['context'] = get(g:,'GoldenView_zl_context','')
"     let message['args']    = a:000
"     call GoldenView#zl#log#info(message)
"   endfunction
"
"   command! -nargs=* -complete=expression Trace
"     \ exec GoldenView#zl#vim#context() | call GoldenView#zl#log#info(<args>)
" --------------------------------%<--------------------------------




function! GoldenView#zl#log#info(...)
    call <SID>setup_ruby()
    ruby << __RUBY__

args = Vim.evaluate('a:000')

case args.size
when 0
  return
when 1
  $GoldenView_zl_logger.info("GoldenView") { args[0].ai(:plain => true) }
when 2
  $GoldenView_zl_logger.info(args[0]) { args[1].ai(:plain => true) }
else
  $GoldenView_zl_logger.info(args[0]) { args[1].ai(:plain => true) }
end
__RUBY__

endfunction

function! GoldenView#zl#log#level_info()
    ruby $GoldenView_zl_logger.level = Logger::INFO
endfunction











function! GoldenView#zl#log#debug(...)
    call <SID>setup_ruby()
    ruby << __RUBY__

args = Vim.evaluate('a:000')

case args.size
when 0
  return
when 1
  $GoldenView_zl_logger.debug("GoldenView") { args[0].ai(:plain => true) }
when 2
  $GoldenView_zl_logger.debug(args[0]) { args[1].ai(:plain => true) }
else
  $GoldenView_zl_logger.debug(args[0]) { args[1].ai(:plain => true) }
end
__RUBY__

endfunction

function! GoldenView#zl#log#level_debug()
    ruby $GoldenView_zl_logger.level = Logger::DEBUG
endfunction











function! GoldenView#zl#log#warn(...)
    call <SID>setup_ruby()
    ruby << __RUBY__

args = Vim.evaluate('a:000')

case args.size
when 0
  return
when 1
  $GoldenView_zl_logger.warn("GoldenView") { args[0].ai(:plain => true) }
when 2
  $GoldenView_zl_logger.warn(args[0]) { args[1].ai(:plain => true) }
else
  $GoldenView_zl_logger.warn(args[0]) { args[1].ai(:plain => true) }
end
__RUBY__

endfunction

function! GoldenView#zl#log#level_warn()
    ruby $GoldenView_zl_logger.level = Logger::WARN
endfunction











function! GoldenView#zl#log#error(...)
    call <SID>setup_ruby()
    ruby << __RUBY__

args = Vim.evaluate('a:000')

case args.size
when 0
  return
when 1
  $GoldenView_zl_logger.error("GoldenView") { args[0].ai(:plain => true) }
when 2
  $GoldenView_zl_logger.error(args[0]) { args[1].ai(:plain => true) }
else
  $GoldenView_zl_logger.error(args[0]) { args[1].ai(:plain => true) }
end
__RUBY__

endfunction

function! GoldenView#zl#log#level_error()
    ruby $GoldenView_zl_logger.level = Logger::ERROR
endfunction











function! GoldenView#zl#log#fatal(...)
    call <SID>setup_ruby()
    ruby << __RUBY__

args = Vim.evaluate('a:000')

case args.size
when 0
  return
when 1
  $GoldenView_zl_logger.fatal("GoldenView") { args[0].ai(:plain => true) }
when 2
  $GoldenView_zl_logger.fatal(args[0]) { args[1].ai(:plain => true) }
else
  $GoldenView_zl_logger.fatal(args[0]) { args[1].ai(:plain => true) }
end
__RUBY__

endfunction

function! GoldenView#zl#log#level_fatal()
    ruby $GoldenView_zl_logger.level = Logger::FATAL
endfunction















endif


" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :


