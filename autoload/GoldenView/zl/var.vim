" =============== ============================================================
" Name           : var.vim
" Synopsis       : vim script library: variable
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Sat 03 Sep 2011 03:54:00 PM EDT
" Last Modified  : Thu 20 Sep 2012 04:25:16 PM EDT
" Tag            : [ vim, variable ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================




" ============================================================================
" Type:                                                                   [[[1
" ============================================================================


"--------- ------------------------------------------------
" Desc    : Wrapper functions for type()
"
" Refer   : vital.vim
"--------- ------------------------------------------------

let [
\   s:__TYPE_NUMBER,
\   s:__TYPE_STRING,
\   s:__TYPE_FUNCREF,
\   s:__TYPE_LIST,
\   s:__TYPE_DICT,
\   s:__TYPE_FLOAT
\] = [
\   type(3),
\   type(""),
\   type(function('tr')),
\   type([]),
\   type({}),
\   has('float') ? type(str2float('0')) : -1
\]
" __TYPE_FLOAT = -1 when -float
" This doesn't match to anything.

" Number or Float
function! GoldenView#zl#var#is_numeric(Value)
  let _ = type(a:Value)
  return _ ==# s:__TYPE_NUMBER
  \   || _ ==# s:__TYPE_FLOAT
endfunction
" Number
function! GoldenView#zl#var#is_integer(Value)
  return type(a:Value) ==# s:__TYPE_NUMBER
endfunction
function! GoldenView#zl#var#is_number(Value)
  return type(a:Value) ==# s:__TYPE_NUMBER
endfunction
" Float
function! GoldenView#zl#var#is_float(Value)
  return type(a:Value) ==# s:__TYPE_FLOAT
endfunction
" String
function! GoldenView#zl#var#is_string(Value)
  return type(a:Value) ==# s:__TYPE_STRING
endfunction
" Funcref
function! GoldenView#zl#var#is_funcref(Value)
  return type(a:Value) ==# s:__TYPE_FUNCREF
endfunction
" List
function! GoldenView#zl#var#is_list(Value)
  return type(a:Value) ==# s:__TYPE_LIST
endfunction
" Dictionary
function! GoldenView#zl#var#is_dict(Value)
  return type(a:Value) ==# s:__TYPE_DICT
endfunction





" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
