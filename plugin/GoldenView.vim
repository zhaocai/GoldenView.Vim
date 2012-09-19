" =============== ============================================================
" Name           : GoldenView
" Description    : Golden view for vim split windows
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/GoldenView.Vim
" Date Created   : Tue 18 Sep 2012 10:25:23 AM EDT
" Last Modified  : Tue 18 Sep 2012 09:22:01 PM EDT
" Tag            : [ vim, window, size, golden-ratio ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================

" ============================================================================
" Load Guard:                                                             [[[1
" ============================================================================
try | if !zlib#rc#load_guard(expand('<sfile>:t:r'), 700, 100, ['!&cp'])
        finish
    endif
catch /^Vim\%((\a\+)\)\=:E117/ " E117: Unknown Function
    throw 'GoldenView: zlib.vim is required!'
endtry

let s:save_cpo = &cpo
set cpo&vim


" ============================================================================
" Settings:                                                               [[[1
" ============================================================================

call zlib#rc#set_default({
    \ 'g:goldenview__enable_at_startup'      : 1         ,
    \ 'g:goldenview__enable_default_mapping' : 1         ,
    \ 'g:goldenview__active_profile'         : 'default' ,
    \ 'g:goldenview__reset_profile'          : 'reset'   ,
    \
    \ })


" ============================================================================
" Public Interface:                                                       [[[1
" ============================================================================

" Auto Resize:
" ------------
command! -nargs=0 GoldenViewToggleAutoResize
            \ call GoldenView#ToggleAutoResize()

command! -nargs=0 GoldenViewDisableAutoResize
            \ call GoldenView#DisableAutoResize()

command! -nargs=0 GoldenViewEnableAutoResize
            \ call GoldenView#EnableAutoResize()

command! -nargs=0 GoldenViewResize
            \ call GoldenView#EnableAutoResize()
            \|call GoldenView#DisableAutoResize()


nnoremap <Plug>GoldenViewToggleAutoResize
            \ :<C-U>GoldenViewToggleAutoResize<CR>

nnoremap <Plug>GoldenViewResize
            \ :<C-U>GoldenViewResize<CR>

" Layout Split:
" -------------
nnoremap <Plug>GoldenViewSplit
            \ :<C-u>call zlib#window#split_nicely()<CR>


" Goto Window:
" ------------
nnoremap <Plug>GoldenViewNext
            \ :<C-u>call zlib#window#next_window_or_tab()<CR>
nnoremap <Plug>GoldenViewPrevious
            \ :<C-u>call zlib#window#previous_window_or_tab()<CR>

" Switch Window:
" --------------
nnoremap <Plug>GoldenViewSwitch
            \ :<C-u>call zlib#window#switch_buffer_toggle()<CR>





" ============================================================================
" Initialization:                                                         [[[1
" ============================================================================
if g:goldenview__enable_at_startup == 1
    GoldenViewEnableAutoResize
endif

if g:goldenview__enable_default_mapping == 1
    nmap <silent> <C-N> <Plug>GoldenViewNext
    nmap <silent> <C-P> <Plug>GoldenViewPrevious

    nmap <silent> <F8> <Plug>GoldenViewSwitch

    nmap <silent> <C-O> <Plug>GoldenViewSplit
endif









let &cpo = s:save_cpo
unlet s:save_cpo

" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :

