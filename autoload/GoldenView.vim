" =============== ============================================================
" Name           : GoldenView
" Description    : Always have a nice view for vim split windows
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/GoldenView.Vim
" Date Created   : Tue 18 Sep 2012 10:25:23 AM EDT
" Last Modified  : Fri 19 Oct 2012 05:55:17 PM EDT
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
    " [TODO]( initialize the other window settings ) @zhaocai @start(2012-09-29 17:01)
    let active_profile = s:goldenview__profile[g:goldenview__active_profile]
    call s:set_focus_window(active_profile)
    call s:set_other_window(active_profile)

    augroup GoldenView
        au!
        autocmd VimResized  * call GoldenView#Resize({'event' : 'VimResized'})
        autocmd BufWinEnter * call GoldenView#Resize({'event' : 'BufWinEnter'})
        autocmd WinEnter    * call GoldenView#Resize({'event' : 'WinEnter'})
    augroup END
    let s:goldenview__auto_resize = 1

endfunction


function! GoldenView#DisableAutoResize()
    au! GoldenView
    call GoldenView#ResetResize()

    let s:goldenview__auto_resize = 0
endfunction


function! GoldenView#Resize(...)
    "--------- ------------------------------------------------
    " Desc    : resize focused window
    "
    " Args    :
    " Return  :
    " Raise   :
    "
    "
    " Pitfall :
    "   - can not set winminwith > winwidth
    "   -
    "
    " AutoCmd :
    "   - `:copen` :
    "     1. WinEnter (&ft inherited from last buffer)
    "     2. BufWinEnter (&ft == '')
    "     3. BufWinEnter (&ft == 'qf', set winfixheight)
    "
    " Refer   :
    " Example : >
    "--------- ------------------------------------------------

    let winnr_diff = s:winnr_diff()
    if winnr_diff > 0
        " New Window:

        silent! call tlog#Log("GoldenView#Resize: winnr plus " . PP(extend(a:1, GoldenView#Info())))
        return
    elseif winnr_diff < 0
        " Win Leave:
        call GoldenView#initialize_tab_variable()
        let saved_lazyredraw = &lazyredraw
        set lazyredraw
        let current_bufnr = bufnr('%')

        " redraw ignored window to its original size
        for nr in zl#list#uniq(tabpagebuflist())
            let buf_saved = get(t:goldenview['bufs'], nr, {})
            if ! empty(buf_saved)
                silent exec bufwinnr(nr) 'wincmd w'

                if GoldenView#IsIgnore()
                    silent exec 'vertical resize ' . buf_saved['winwidth']
                    silent exec 'resize ' . buf_saved['winheight']
                    silent! call tlog#Log("GoldenView#Resize: bufs saved " . bufname(nr) . " : " . PP(buf_saved))
                endif
            endif
        endfor

        if &cmdheight != t:goldenview['cmdheight']
            silent exec 'set cmdheight=' . t:goldenview['cmdheight']
        endif

        silent exec bufwinnr(current_bufnr) 'wincmd w'

        redraw
        let &lazyredraw = saved_lazyredraw

        silent! call tlog#Log("GoldenView#Resize: winnr minus " . PP(extend(a:1, GoldenView#Info())))
        return
    endif

    silent! call tlog#Log("GoldenView#Resize: enter " . PP(extend(a:1, GoldenView#Info())))

    if GoldenView#IsIgnore()
        " Do nothing if there is no split window
        if winnr('$') > 1
            call GoldenView#initialize_tab_variable()
            let t:goldenview['bufs'][bufnr('%')] = {
            \  'winwidth'  : winwidth(0)  , 
            \  'winheight' : winheight(0) , 
            \ } 
            silent! call tlog#Log("GoldenView#Resize: ignore " . PP(extend(a:1, GoldenView#Info())))
        end
        return
    endif

    let active_profile = s:goldenview__profile[g:goldenview__active_profile]
    call s:set_focus_window(active_profile)
    silent! call tlog#Log("GoldenView#Resize: set focus " . PP(extend(a:1, GoldenView#Info())))

    " reset focus windows minimal size
    let &winheight = &winminheight
    let &winwidth  = &winminwidth
    silent! call tlog#Log("GoldenView#Resize: reset focus " . PP(extend(a:1, GoldenView#Info())))
endfunction

function! GoldenView#IsIgnore()
    return zl#rule#is_true(s:goldenview__ignore_nrule)
endfunction


function! GoldenView#ResetResize()
    let reset_profile = s:goldenview__profile[g:goldenview__reset_profile]
    call s:set_other_window(reset_profile, {'force' : 1})
    call s:set_focus_window(reset_profile, {'force' : 1})
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
        return float2nr(tw * 4/3)
    else
        let tw = float2nr(80 * 4/3)
        let gw = GoldenView#GoldenWidth()
        return tw > gw ? gw : tw
    endif
endfunction


function! s:set_focus_window(profile,...)
    let opts = {
             \ 'force' : 0
             \ }
    if a:0 >= 1 && zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    try
        if !&winfixwidth || opts['force']
            let &winwidth  =
            \ s:eval(a:profile, a:profile['focus_window_winwidth'])
        endif
        if !&winfixheight || opts['force']
            let &winheight =
            \ s:eval(a:profile, a:profile['focus_window_winheight'])
        endif
    catch /^Vim\%((\a\+)\)\=:E36/ " Not enough room
        call zl#print#warning('GoldenView: ' . v:exception)
    endtry
endfunction

" [TODO]( should not check &winfixheight here ) @zhaocai @start(2012-09-29 16:57)
function! s:set_other_window(profile,...)
    let opts = {
             \ 'force' : 0
             \ }
    if a:0 >= 1 && zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    try
        if !&winfixwidth || opts['force']
            silent! call tlog#Log("a:profile: " . PP(a:profile))
            silent! call tlog#Log("winminwidth: " . PP(s:eval(a:profile, a:profile['other_window_winwidth'])))
            let &winminwidth  =
            \ s:eval(a:profile, a:profile['other_window_winwidth'])
        endif
        if !&winfixheight || opts['force']
            let &winminheight =
            \ s:eval(a:profile, a:profile['other_window_winheight'])
        endif
    catch /^Vim\%((\a\+)\)\=:E36/ " Not enough room
        call zl#print#warning('GoldenView: ' . v:exception)
    endtry
endfunction


" ============================================================================
" Helper Functions:                                                       [[[1
" ============================================================================
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

function! GoldenView#initialize_tab_variable()
    if !exists('t:goldenview')
        let t:goldenview = {
        \ 'nrwin'     : winnr('$') , 
        \ 'cmdheight' : &cmdheight , 
        \ 'bufs'      : {} , 
        \ }
    endif
endfunction

function! s:winnr_diff()
    call GoldenView#initialize_tab_variable()

    let nrwin = winnr('$')
    if nrwin != t:goldenview['nrwin']
        let diff = nrwin - t:goldenview['nrwin']
        let t:goldenview['nrwin'] = nrwin
        return diff
    else
        return 0
    endif
endfunction




" ============================================================================
" Debug:                                                                  [[[1
" ============================================================================
function! GoldenView#Info()
    return {
    \ 'buffer' : {
    \   'filetype'  : &ft          ,
    \   'buftype'   : &buftype     ,
    \   'bufname'   : bufname('%') ,
    \   'winwidth'  : winwidth(0)  ,
    \   'winheight' : winheight(0) ,
    \ },
    \ 'setting' : {
    \   'lazyredraw'   : &lazyredraw  ,
    \   'winfixwidth'  : &winfixwidth  ,
    \   'winfixheight' : &winfixheight ,
    \   'winwidth'     : &winwidth     ,
    \   'winminwidth'  : &winminwidth  ,
    \   'winheight'    : &winheight    ,
    \   'winminheight' : &winminheight ,
    \ }
    \}
endfunction



" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :
