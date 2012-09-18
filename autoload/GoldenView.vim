" =============== ============================================================
" Name           : GoldenView
" Description    : Golden view for vim split windows
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/GoldenView.Vim
" Date Created   : Tue 18 Sep 2012 10:25:23 AM EDT
" Last Modified  : Tue 18 Sep 2012 04:38:47 PM EDT
" Tag            : [ vim, window, golden-ratio ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================


" ============================================================================
" Initialization:                                                         [[[1
" ============================================================================
function! GoldenView#Init()
    if exists('g:goldenview__initialized') && g:goldenview__initialized == 1
        return
    endif
    let s:golden_ratio = 1.618

    call zlib#rc#set_default({
        \ 'g:goldenview__active_profile' : 'default' ,
        \ 'g:goldenview__reset_profile'  : 'reset'   ,
        \ 'g:goldenview__profile' : {
        \   'reset' : {
        \     'focus_window' : {
        \       'winheight' : &winheight ,
        \       'winwidth'  : &winwidth  ,
        \     },
        \     'other_window' : {
        \       'winheight' : &winminheight ,
        \       'winwidth'  : &winminwidth  ,
        \     },
        \   },
        \   'default' : {
        \     'focus_window' : {
        \       'winheight' : function('GoldenView#GoldenHeight') ,
        \       'winwidth'  : function('GoldenView#GoldenWidth')  ,
        \     },
        \     'other_window' : {
        \       'winheight' : 3                               ,
        \       'winwidth'  : float2nr(3 * &columns / &lines) ,
        \     },
        \   },
        \ },
        \
        \ })
    let g:goldenview__initialized = 1
endfunction

" ============================================================================
" Auto Resize:                                                            [[[1
" ============================================================================
function! GoldenView#ToggleAutoResize()
    if exists('s:goldenview__auto_resize') && s:goldenview__auto_resize == 1
        call GoldenView#DisableAutoResize()
    else
        call GoldenView#EnableAutoResize()
    endif
endfunction


function! GoldenView#EnableAutoResize()
    call GoldenView#Resize()
    augroup GoldenView
        au!
        autocmd VimResized * call GoldenView#Resize()
        autocmd BufEnter,WinEnter * let &winwidth = &textwidth + 2
    augroup END
    let s:goldenview__auto_resize = 1

    call zlib#print#moremsg('GoldenView Auto Resize: On')
endfunction


function! GoldenView#DisableAutoResize()
    au! GoldenView
    call GoldenView#ResetResize()

    let s:goldenview__auto_resize = 0
    call zlib#print#moremsg('GoldenView Auto Resize: Off')
endfunction




function! GoldenView#Resize()
    let profile = g:goldenview__profile[g:goldenview__active_profile]
    call s:set_other_window(profile)
    call s:set_focus_window(profile)
endfunction


function! GoldenView#ResetResize()
    let profile = g:goldenview__profile[g:goldenview__reset_profile]
    call s:set_other_window(profile)
    call s:set_focus_window(profile)
endfunction

function! GoldenView#GoldenHeight(profile)
    return float2nr(&lines / s:golden_ratio)
endfunction

function! GoldenView#GoldenWidth(profile)

    let ww = winwidth(0)
    let tw = &l:textwidth

    if tw != 0 && ww > tw
        return tw + a:profile['other_window']['winwidth']
    else
        return float2nr(&columns / s:golden_ratio)
    endif

endfunction

function s:set_focus_window(profile)
    let &winwidth  = s:eval(a:profile, a:profile['focus_window']['winwidth'])
    let &winheight = s:eval(a:profile, a:profile['focus_window']['winheight'])
endfunction

function s:set_other_window(profile)
    let &winminwidth  = s:eval(a:profile, a:profile['other_window']['winwidth'])
    let &winminheight = s:eval(a:profile, a:profile['other_window']['winheight'])
endfunction

function s:eval(profile, val)
    if type(a:val) == type(1)
        return a:val
    elseif type(a:val) == type(function('type'))
        return a:val(a:profile)
    else
        throw 'GoldenView: invalid profile value type!'
    endif
endfunction

call GoldenView#Init()
" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :
