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
" Initialization And Profile:                                             ⟨⟨⟨1
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

    set equalalways
    set eadirection=ver


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

    let s:goldenview__ignore_nrule = GoldenView#zl#rule#norm(
    \   g:goldenview__ignore_urule, {
    \     'logic' : 'or',
    \   }
    \ )

    let s:goldenview__restore_nrule = GoldenView#zl#rule#norm(
    \   g:goldenview__restore_urule, {
    \     'logic' : 'or',
    \   }
    \ )
    let g:goldenview__initialized = 1
endfunction



" ============================================================================
" Auto Resize:                                                            ⟨⟨⟨1
" ============================================================================
function! GoldenView#ToggleAutoResize()
    if exists('s:goldenview__auto_resize') && s:goldenview__auto_resize == 1
        call GoldenView#DisableAutoResize()
        call GoldenView#zl#print#moremsg('GoldenView Auto Resize: Off')
    else
        call GoldenView#EnableAutoResize()
        call GoldenView#zl#print#moremsg('GoldenView Auto Resize: On')
    endif
endfunction


function! GoldenView#EnableAutoResize()

    call GoldenView#Init()

    let active_profile = s:goldenview__profile[g:goldenview__active_profile]
    call s:set_focus_window(active_profile)
    call s:set_other_window(active_profile)

    augroup GoldenView
        au!
        " Enter
        autocmd VimResized  * call GoldenView#Enter({'event' : 'VimResized'})
        autocmd BufWinEnter * call GoldenView#Enter({'event' : 'BufWinEnter'})
        autocmd WinEnter    * call GoldenView#Enter({'event' : 'WinEnter'})

        " Leave
        autocmd WinLeave    * call GoldenView#Leave()
    augroup END
    let s:goldenview__auto_resize = 1

endfunction


function! GoldenView#DisableAutoResize()
    au! GoldenView
    call GoldenView#ResetResize()

    let s:goldenview__auto_resize = 0
endfunction

function! GoldenView#Leave(...)

    " GoldenViewTrace 'WinLeave', a:000

    " Do nothing if there is no split window
    " --------------------------------------
    if winnr('$') < 2
        return
    endif

    call GoldenView#Diff()

    if GoldenView#IsIgnore()
        " Record the last size of ignored windows. Restore there sizes if affected
        " by GoldenView.

        " For new split, the size does not count, which is highly possible
        " to be resized later. Should use the size with WinLeave event.
        "
        call GoldenView#initialize_tab_variable()
        let t:goldenview['bufs'][bufnr('%')] = {
        \  'winnr'     : winnr()  ,
        \  'winwidth'  : winwidth(0)  ,
        \  'winheight' : winheight(0) ,
        \ }
        let t:goldenview['cmdheight'] = &cmdheight
    end
endfunction

function! GoldenView#Diff()
    " Diff Mode: auto-resize to equal size
    if ! exists('b:goldenview_diff')
        let b:goldenview_diff = 0
    endif
    if &diff
        if ! b:goldenview_diff
            for nr in GoldenView#zl#list#uniq(tabpagebuflist())
                if getbufvar(nr, '&diff')
                    call setbufvar(nr, 'goldenview_diff', 1)
                endif
            endfor
            exec 'wincmd ='
        endif
        return 1
    else
        if b:goldenview_diff
            let b:goldenview_diff = 0
        endif
    endif
    return 0
endfunction

function! GoldenView#Enter(...)

    if GoldenView#Diff()
        return
    endif

    if &lazyredraw
        return
    endif

    return call('GoldenView#Resize', a:000)
endfunction

function! GoldenView#Resize(...)
    "--------- ------------------------------------------------
    " Desc    : resize focused window
    "
    " Args    : {'event' : event}
    " Return  : none
    "
    " Raise   : none from this function
    "
    " Pitfall :
    "   - Can not set winminwith > winwidth
    "   - AutoCmd Sequence:
    "     - `:copen` :
    "       1. WinEnter (&ft inherited from last buffer)
    "       2. BufWinEnter (&ft == '')
    "       3. BufWinEnter (&ft == 'qf', set winfixheight)
    "     - `:split`
    "       1. WinLeave current window
    "       2. WinEnter new split window with current buffer
    "       3. `split` return, user script may change the buffer
    "          type, width, etc.
    "
    "
    "--------- ------------------------------------------------

    " GoldenViewTrace 'GoldenView Resize', a:000

    let opts = {'is_force' : 0}
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    let winnr_diff = s:winnr_diff()
    if winnr_diff > 0
        " Plus Split Window:
        " ++++++++++++++++++

        " GoldenViewTrace '+++ winnr +++', a:000
        return

    elseif winnr_diff < 0
        " Minus Split Window:
        " -------------------

        call GoldenView#initialize_tab_variable()
        let saved_lazyredraw = &lazyredraw
        set lazyredraw
        let current_winnr = winnr()

        " Restore: original size based on "g:goldenview__restore_urule"
        " ------------------------------------------------------------
        for winnr in range(1, winnr('$'))
            let bufnr = winbufnr(winnr)
            let bufsaved = get(t:goldenview['bufs'], bufnr, {})

            " Ignored Case: same buffer displayed in multiply windows
            " -------------------------------------------------------
            if ! empty(bufsaved) && bufsaved['winnr'] == winnr
                silent noautocmd exec winnr 'wincmd w'

                if GoldenView#IsRestore()
                    silent exec 'vertical resize ' . bufsaved['winwidth']
                    silent exec 'resize ' . bufsaved['winheight']

                    " GoldenViewTrace 'restore buffer:'. nr, a:000
                endif
            endif
        endfor

        if &cmdheight != t:goldenview['cmdheight']
            exec 'set cmdheight=' . t:goldenview['cmdheight']
        endif

        silent exec current_winnr 'wincmd w'

        redraw
        let &lazyredraw = saved_lazyredraw

        " GoldenViewTrace '--- winnr ---', a:000
        return
    endif

    if ! opts['is_force']

        " Do nothing if there is no split window
        if winnr('$') < 2
            return
        endif

        if GoldenView#IsIgnore()
            " GoldenViewTrace 'Ignored', a:000
            return
        endif

    endif


    let active_profile = s:goldenview__profile[g:goldenview__active_profile]
    call s:set_focus_window(active_profile)
    " GoldenViewTrace 'Set Focuse', a:000



    " reset focus windows minimal size
    let &winheight = &winminheight
    let &winwidth  = &winminwidth

    " GoldenViewTrace 'Reset Focus', a:000
endfunction

function! GoldenView#IsIgnore()
    return GoldenView#zl#rule#is_true(s:goldenview__ignore_nrule)
endfunction

function! GoldenView#IsRestore()
    return GoldenView#zl#rule#is_true(s:goldenview__restore_nrule)
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
    return float2nr(GoldenView#GoldenHeight()/(5*s:goldenview__golden_ratio))
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
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
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
        call GoldenView#zl#print#warning('GoldenView: ' . v:exception)
    endtry
endfunction

function! s:set_other_window(profile,...)
    let opts = {
             \ 'force' : 0
             \ }
    if a:0 >= 1 && GoldenView#zl#var#is_dict(a:1)
        call extend(opts, a:1)
    endif

    try
        if !&winfixwidth || opts['force']
            let &winminwidth  =
            \ s:eval(a:profile, a:profile['other_window_winwidth'])
        endif
        if !&winfixheight || opts['force']
            let &winminheight =
            \ s:eval(a:profile, a:profile['other_window_winheight'])
        endif
    catch /^Vim\%((\a\+)\)\=:E36/ " Not enough room
        call GoldenView#zl#print#warning('GoldenView: ' . v:exception)
    endtry
endfunction





" ============================================================================
" Split:                                                                  ⟨⟨⟨1
" ============================================================================
function! GoldenView#Split()
    call GoldenView#zl#window#split_nicely()
endfunction



" ============================================================================
" Switch:                                                                 ⟨⟨⟨1
" ============================================================================
function! GoldenView#SwitchMain(...)
    let opts = {
                \ 'from_bufnr' : bufnr('%') ,
            \}
    if a:0 >= 1 && type(a:1) == type({})
        call extend(opts, a:1)
    endif

    let window_count = winnr('$')
    if window_count < 2
        return
    endif

    let current_winnr = winnr()
    let switched      = 0

    let saved_lazyredraw = &lazyredraw
    set lazyredraw
    for i in range(1, window_count)
        silent noautocmd exec i 'wincmd w'

        if ! GoldenView#IsIgnore()
            let switched = GoldenView#zl#window#switch_buffer(
                \ opts['from_bufnr'], winbufnr(i))
            break
        endif
    endfor

    redraw
    let &lazyredraw = saved_lazyredraw

    if switched
        call GoldenView#Resize({'event' : 'WinEnter'})
    else
        silent noautocmd exec current_winnr 'wincmd w'
    endif
endfunction

" ============================================================================
" Helper Functions:                                                       ⟨⟨⟨1
" ============================================================================

function! s:eval(profile, val)
    if GoldenView#zl#var#is_number(a:val)
        return a:val
    elseif GoldenView#zl#var#is_funcref(a:val)
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
" Debug:                                                                  ⟨⟨⟨1
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
    \ 'goldenview'  : get(t:, 'goldenview', GoldenView#initialize_tab_variable()),
    \ 'setting' : {
    \   'win_count'    : winnr('$')    ,
    \   'lazyredraw'   : &lazyredraw   ,
    \   'cmdheight'    : &cmdheight    ,
    \   'winfixwidth'  : &winfixwidth  ,
    \   'winfixheight' : &winfixheight ,
    \   'winwidth'     : &winwidth     ,
    \   'winminwidth'  : &winminwidth  ,
    \   'winheight'    : &winheight    ,
    \   'winminheight' : &winminheight ,
    \ }
    \}
endfunction


function! GoldenView#Trace(...)
    " -------- - -----------------------------------------------
    "  Example : >
    "    GoldenViewTrace 'WinLeave', a:000
    " -------- - -----------------------------------------------

    call GoldenView#initialize_tab_variable()
    let info            = GoldenView#Info()
    let info['context'] = get(g:,'GoldenView_zl_context','')
    let info['args']    = a:000
    call GoldenView#zl#log#debug(info)
endfunction

command! -nargs=* -complete=expression GoldenViewTrace
    \ exec GoldenView#zl#vim#context() | call GoldenView#Trace(<args>)

" ============================================================================
" Modeline:                                                               ⟨⟨⟨1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=⟨⟨⟨,⟩⟩⟩ fdl=1 :
