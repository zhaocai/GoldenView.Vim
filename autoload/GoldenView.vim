" =============== ============================================================
" Name           : GoldenView
" Description    : Golden view for vim split windows
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/GoldenView.Vim
" Date Created   : Tue 18 Sep 2012 10:25:23 AM EDT
" Last Modified  : Thu 20 Sep 2012 06:24:13 PM EDT
" Tag            : [ vim, window, golden-ratio ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================


" ============================================================================
" Initialization And Profile:                                             [[[1
" ============================================================================
function! GoldenView#ExtendProfile(name, def)
    let default = get(s:goldenview__profile, a:name,
                \ copy(s:goldenview__profile['default']))

    let s:goldenview__profile[a:name] = extend(default, a:def)
endfunction

function! GoldenView#Init()
    if exists('g:goldenview__initialized') && g:goldenview__initialized == 1
        return
    endif
    let s:goldenview__golden_ratio = 1.618
    lockvar s:goldenview__golden_ratio


    let s:goldenview__profile = {
    \ 'reset'   : {
    \   'focus_window_winheight' : &winheight    ,
    \   'focus_window_winwidth'  : &winwidth     ,
    \   'other_window_winheight' : &winminheight ,
    \   'other_window_winwidth'  : &winminwidth  ,
    \ },
    \ 'default' : {
    \   'focus_window_winheight' : function('GoldenView#GoldenHeight')    ,
    \   'focus_window_winwidth'  : function('GoldenView#TextWidth')       ,
    \   'other_window_winheight' : function('GoldenView#GoldenMinHeight') ,
    \   'other_window_winwidth'  : function('GoldenView#GoldenMinWidth')  ,
    \ },
    \
    \ }

    call GoldenView#ExtendProfile('golden-ratio', {
    \   'focus_window_winwidth'  : function('GoldenView#GoldenWidth')  ,
    \ })

    let s:goldenview__ignore_nrule = zl#rule#norm(
    \   g:goldenview__ignore_urule, {
    \     'logic' : 'or',
    \   }
    \ )
    let g:goldenview__initialized = 1
endfunction

call GoldenView#Init()



" ============================================================================
" Auto Resize:                                                            [[[1
" ============================================================================
function! GoldenView#ToggleAutoResize()
    if exists('s:goldenview__auto_resize') && s:goldenview__auto_resize == 1
        call GoldenView#DisableAutoResize()
        call zl#print#moremsg('GoldenView Auto Resize: Off')
    else
        call GoldenView#EnableAutoResize()
        call zl#print#moremsg('GoldenView Auto Resize: On')
    endif
endfunction


function! GoldenView#EnableAutoResize()
    call GoldenView#Resize()
    augroup GoldenView
        au!
        autocmd VimResized * call GoldenView#Resize()
        autocmd BufWinEnter,WinEnter * call GoldenView#Resize()
    augroup END
    let s:goldenview__auto_resize = 1

endfunction


function! GoldenView#DisableAutoResize()
    au! GoldenView
    call GoldenView#ResetResize()

    let s:goldenview__auto_resize = 0
endfunction


function! GoldenView#Resize()
    " Note: winminwith < winwidth

    if GoldenView#IsIgnore()
        call GoldenView#ResetResize()
        return
    endif

    let active_profile = s:goldenview__profile[g:goldenview__active_profile]
    call s:set_focus_window(active_profile)
    call s:set_other_window(active_profile)

endfunction

function! GoldenView#IsIgnore()
    return zl#rule#is_true(s:goldenview__ignore_nrule)
endfunction


function! GoldenView#ResetResize()
    let reset_profile = s:goldenview__profile[g:goldenview__reset_profile]
    call s:set_other_window(reset_profile)
    call s:set_focus_window(reset_profile)
endfunction


function! GoldenView#GoldenHeight(...)
    return float2nr(&lines / s:goldenview__golden_ratio)
endfunction


function! GoldenView#GoldenWidth(...)
    return float2nr(&columns / s:goldenview__golden_ratio)
endfunction


function! GoldenView#GoldenMinHeight(...)
    return float2nr(GoldenView#GoldenHeight()/(3*s:goldenview__golden_ratio))
endfunction


function! GoldenView#GoldenMinWidth(...)
    return float2nr(GoldenView#GoldenWidth()/(3*s:goldenview__golden_ratio))
endfunction


function! GoldenView#TextWidth(...)
    let tw = &l:textwidth

    if tw != 0
        return tw + 2
    else
        let gw = GoldenView#GoldenWidth()
        return gw > 80 ? 80 : gw
    endif
endfunction


function! s:set_focus_window(profile)
    try
        let &winwidth  = s:eval(a:profile, a:profile['focus_window_winwidth'])
        let &winheight = s:eval(a:profile, a:profile['focus_window_winheight'])
    catch /^Vim\%((\a\+)\)\=:E36/ " Not enough room
        " call zl#print#warning('GoldenView:' . v:exception)
    endtry
endfunction


function! s:set_other_window(profile)
    try
        let &winminwidth  = s:eval(a:profile, a:profile['other_window_winwidth'])
        let &winminheight = s:eval(a:profile, a:profile['other_window_winheight'])
    catch /^Vim\%((\a\+)\)\=:E36/ " Not enough room
        " call zl#print#warning('GoldenView:' . v:exception)
    endtry
endfunction


function! s:eval(profile, val)
    if zl#var#is_number(a:val)
        return a:val
    elseif zl#var#is_funcref(a:val)
        return a:val(a:profile)
    else
        try
            return eval(a:val)
        catch /^Vim\%((\a\+)\)\=:E/
            throw 'GoldenView: invalid profile value type!'
        endtry
    endif
endfunction

" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :
