" =============== ============================================================
" Name           : GoldenView
" Description    : Golden view for vim split windows
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/GoldenView.Vim
" Date Created   : Tue 18 Sep 2012 10:25:23 AM EDT
" Last Modified  : Tue 18 Sep 2012 04:15:38 PM EDT
" Tag            : [ vim, window, golden-ratio ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================

" ============================================================================
" Load Guard:                                                             [[[1
" ============================================================================
try | if !zlib#rc#load_guard(expand('<sfile>:t:r'), 700, 100, ['!&cp'])
        finish
    endif
catch /^Vim%((a+))=:E117/ " E117: Unknown Function
    throw 'GoldenView: zlib.vim is required!'
endtry

let s:save_cpo = &cpo
set cpo&vim


" ============================================================================
" Settings:                                                               [[[1
" ============================================================================

call zlib#rc#set_default({
    \ 'g:goldenview__enable_at_startup'      : 1 ,
    \ 'g:goldenview__enable_default_mapping' : 1 ,
    \
    \ })


" ============================================================================
" Public Interface:                                                       [[[1
" ============================================================================

command! -nargs=0 GoldenViewToggleAutoResize call GoldenView#ToggleAutoResize()



nnoremap <Plug>GoldenViewToggleAutoResize :<C-U>call GoldenView#ToggleAutoResize()<CR>


if g:goldenview__enable_default_mapping == 1

    nnoremap <silent> <C-O> :<C-u>call zlib#window#split_nicely()<CR>
    nnoremap <silent> <C-N> :<C-u>call zlib#window#next_window_or_tab()<CR>
    nnoremap <silent> <C-P> :<C-u>call zlib#window#previous_window_or_tab()<CR>
endif



" ============================================================================
" Helper Functions:                                                       [[[1
" ============================================================================


if g:goldenview__enable_at_startup == 1
    GoldenViewToggleAutoResize
endif




let &cpo = s:save_cpo
unlet s:save_cpo

" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :

