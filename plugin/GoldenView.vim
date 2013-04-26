" =============== ============================================================
" Name           : GoldenView
" Description    : Golden view for vim split windows
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/GoldenView.Vim
" Date Created   : Tue 18 Sep 2012 10:25:23 AM EDT
" Last Modified  : Sat 29 Sep 2012 01:23:02 AM EDT
" Tag            : [ vim, window, size, golden-ratio ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================

" ============================================================================
" Load Guard:                                                             [[[1
" ============================================================================
if !GoldenView#zl#rc#load_guard(
	\ expand('<sfile>:t:r'), 700, 130, ['!&cp', "has('float')"])
    finish
endif

let s:save_cpo = &cpo
set cpo&vim


" ============================================================================
" Settings:                                                               [[[1
" ============================================================================

call GoldenView#zl#rc#set_default({
    \ 'g:goldenview__enable_at_startup'      : 1         ,
    \ 'g:goldenview__enable_default_mapping' : 1         ,
    \ 'g:goldenview__active_profile'         : 'default' ,
    \ 'g:goldenview__reset_profile'          : 'reset'   ,
    \ 'g:goldenview__ignore_urule'           : {
    \   'filetype' : [
    \     ''        ,
    \     'qf'      , 'vimpager', 'undotree', 'tagbar',
    \     'nerdtree', 'vimshell', 'vimfiler', 'voom'  ,
    \     'tabman'  , 'unite'   , 'quickrun', 'Decho' ,
    \     'ControlP', 'diff'
    \   ],
    \   'buftype' : [
    \     'nofile'  ,
    \   ],
    \   'bufname' : [
    \     'GoToFile'                  , 'diffpanel_\d\+'      , 
    \     '__Gundo_Preview__'         , '__Gundo__'           , 
    \     '\[LustyExplorer-Buffers\]' , '\-MiniBufExplorer\-' , 
    \     '_VOOM\d\+$'                , '__Urannotate_\d\+__' , 
    \     '__MRU_Files__' , 'FencView_\d\+$'
    \   ],
    \ },
    \ 'g:goldenview__restore_urule'           : {
    \   'filetype' : [
    \     'nerdtree', 'vimfiler',
    \   ],
    \   'bufname' : [
    \     '__MRU_Files__' , 
    \   ],
    \ },
    \
    \ })



" ============================================================================
" Public Interface:                                                       [[[1
" ============================================================================



" Auto Resize:
" ------------
command! -nargs=0 ToggleGoldenViewAutoResize
\ call GoldenView#ToggleAutoResize()

command! -nargs=0 DisableGoldenViewAutoResize
\ call GoldenView#DisableAutoResize()

command! -nargs=0 EnableGoldenViewAutoResize
\ call GoldenView#EnableAutoResize()

nnoremap <Plug>ToggleGoldenViewAutoResize
\ :<C-U>ToggleGoldenViewAutoResize<CR>



" Manual Resize:
" --------------
command! -nargs=0 GoldenViewResize
\ call GoldenView#EnableAutoResize()
\|call GoldenView#DisableAutoResize()

nnoremap <Plug>GoldenViewResize
\ :<C-U>GoldenViewResize<CR>



" Layout Split:
" -------------
nnoremap <Plug>GoldenViewSplit
\ :<C-u>call GoldenView#Split()<CR>
" [TODO]( define comfortable width &tw * 4/3) @zhaocai @start(2012-09-29 01:17)



" Goto Window:
" ------------
nnoremap <Plug>GoldenViewNext
\ :<C-u>call GoldenView#zl#window#next_window_or_tab()<CR>

nnoremap <Plug>GoldenViewPrevious
\ :<C-u>call GoldenView#zl#window#previous_window_or_tab()<CR>



" Switch Window:
" --------------
nnoremap <Plug>GoldenViewSwitchMain
\ :<C-u>call GoldenView#SwitchMain()<CR>
command! -nargs=0 SwitchGoldenViewMain
\ call GoldenView#SwitchMain()


nnoremap <Plug>GoldenViewSwitchToggle
\ :<C-u>call GoldenView#zl#window#switch_buffer_toggle()<CR>
command! -nargs=0 SwitchGoldenViewToggle
\ call GoldenView#zl#window#switch_buffer_toggle()


nnoremap <Plug>GoldenViewSwitchWithLargest
\ :<C-u>call GoldenView#zl#window#switch_buffer_with_largest()<CR>
command! -nargs=0 SwitchGoldenViewLargest
\ call GoldenView#zl#window#switch_buffer_with_largest()


nnoremap <Plug>GoldenViewSwitchWithSmallest
\ :<C-u>call GoldenView#zl#window#switch_buffer_with_smallest()<CR>
command! -nargs=0 SwitchGoldenViewSmallest
\ call GoldenView#zl#window#switch_buffer_with_smallest()




" ============================================================================
" Initialization:                                                         [[[1
" ============================================================================
if g:goldenview__enable_at_startup == 1
    call GoldenView#EnableAutoResize()
endif

if g:goldenview__enable_default_mapping == 1
    nmap <silent> <C-N>  <Plug>GoldenViewNext
    nmap <silent> <C-P>  <Plug>GoldenViewPrevious

    nmap <silent> <F8>   <Plug>GoldenViewSwitchMain
    nmap <silent> <S-F8> <Plug>GoldenViewSwitchToggle

    nmap <silent> <C-L>  <Plug>GoldenViewSplit
endif









let &cpo = s:save_cpo
unlet s:save_cpo

" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :

