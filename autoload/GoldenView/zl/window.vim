" =============== ============================================================
" Name           : window.vim
" Synopsis       : vim script library: window
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Version        : 0.1
" Date Created   : Sat 03 Sep 2011 03:54:00 PM EDT
" Last Modified  : Tue 23 Oct 2012 04:59:06 PM EDT
" Tag            : [ vim, syntax ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================



" ============================================================================
" Status:                                                                 ⟨⟨⟨1
" ============================================================================
call GoldenView#zl#rc#set_default({
    \ 'g:GoldenView_zl_window__ignore_urule'           : {
    \   'filetype' : [
    \     ''        ,
    \     'qf'      , 'vimpager', 'undotree', 'tagbar',
    \     'nerdtree', 'vimshell', 'vimfiler', 'voom'  ,
    \     'tabman'  , 'unite'   , 'quickrun', 'Decho' ,
    \   ],
    \   'buftype' : [
    \     'nofile'  ,
    \   ],
    \   'bufname' : [
    \     'GoToFile'                  , 'diffpanel_\d\+'      ,
    \     '__Gundo_Preview__'         , '__Gundo__'           ,
    \     '\[LustyExplorer-Buffers\]' , '\-MiniBufExplorer\-' ,
    \     '_VOOM\d\+$'                , '__Urannotate_\d\+__' ,
    \     '__MRU_Files__' ,
    \   ],
    \ },
    \ })

let s:GoldenView_zl_window__ignore_nrule = GoldenView#zl#rule#norm(
    \   g:GoldenView_zl_window__ignore_urule, {
    \     'logic' : 'or',
    \   }
    \ )

function! GoldenView#zl#window#is_last_visible()
    "--------- ------------------------------------------------
    " Desc    : check if no visible buffer left
    "
    " Args    :
    "
    " Return  :
    "   - 0 : false
    "   - 1 : true
    " Raise   :
    "
    "--------- ------------------------------------------------

    for i in range(tabpagenr('$'))
        let tabnr = i + 1
        for bufnr in tabpagebuflist(tabnr)
            let ft = getbufvar(bufnr, '&ft')
            let buftype = getbufvar(bufnr, '&buftype')
            if empty(ft) && empty(buftype)
                continue
            endif
            if ! GoldenView#zl#rule#is_true(s:GoldenView_zl_window__ignore_nrule)
                return 0
            endif
        endfor
    endfor

    return 1
endfunction





" ============================================================================
" Move:                                                                   ⟨⟨⟨1
" ============================================================================
let l:golden_ratio_dot = str2float("1.618")
let l:golden_ratio_comma = str2float("1,618")
if l:golden_ratio_dot > l:golden_ratio_comma
    let s:golden_ratio = l:golden_ratio_dot
else
    let s:golden_ratio = l:golden_ratio_comma
endif

function! GoldenView#zl#window#next_window_or_tab()
    if tabpagenr('$') == 1 && winnr('$') == 1
        call GoldenView#zl#window#split_nicely()
    elseif winnr() < winnr("$")
        wincmd w
    else
        tabnext
        wincmd w
    endif
endfunction

function! GoldenView#zl#window#previous_window_or_tab()
    if winnr() > 1
        wincmd W
    else
        tabprevious
        execute winnr("$") . "wincmd w"
    endif
endfunction



" ============================================================================
" Size:                                                                   ⟨⟨⟨1
" ============================================================================
function! GoldenView#zl#window#golden_ratio_width()
    return float2nr(&columns / s:golden_ratio)
endfunction

function! GoldenView#zl#window#golden_ratio_height()
    return float2nr(&lines / s:golden_ratio)
endfunction

function! GoldenView#zl#window#textwidth()
    return &tw == 0 ? 78 : &tw
endfunction

" ============================================================================
" Split:                                                                  ⟨⟨⟨1
" ============================================================================

function! GoldenView#zl#window#nicely_split_cmd(...)
    let opts = {
                \ 'winnr' : 0 ,
            \}
    if a:0 >= 1 && type(a:1) == type({})
        call extend(opts, a:1)
    endif

    let ww = winwidth(opts['winnr'])
    let tw = &textwidth

    if tw != 0 && ww > s:golden_ratio * tw
        return 'vsplit'
    endif

    if ww > &columns / s:golden_ratio
        return 'vsplit'
    endif

    return 'split'
endfunction

function! GoldenView#zl#window#split_nicely()
    let split_cmd = GoldenView#zl#window#nicely_split_cmd()
    try
        exec split_cmd
    catch /^Vim\%((\a\+)\)\=:E36/
        if split_cmd == 'split'
            let &winminheight = &winminheight / 2
        else
            let &winminwidth = &winminwidth / 2
        endif
        exec split_cmd
    endtry
    wincmd p
endfunction

function! GoldenView#zl#window#toggle_split()
    let prev_name = winnr()
    silent! wincmd w
    if prev_name == winnr()
        split
    else
        call GoldenView#zl#buf#quit()
    endif
endfunction



" ============================================================================
" Sort:                                                                   ⟨⟨⟨1
" ============================================================================
function! GoldenView#zl#window#sort_by(...)
    "--------- ------------------------------------------------
    " Desc    : sort buffer by size, height, or width
    "
    " Args    :
    "   - opts : > ↓
    "   {
    "     'by'            : size|height|width|winnr|bufnr ,
    "     'tabnr'         : tabpagenr()                   ,
    "     'width_weight'  : s:golden_ratio                ,
    "     'height_weight' : 1                             ,
    "   }
    "
    " Return  : sorted list of
    "   {
    "     'bufnr'  : bufnr  ,
    "     'winnr'  : winnr  ,
    "     'width'  : width  ,
    "     'height' : height ,
    "     'size'   : size   ,
    "   }
    "
    " Raise   :
    "
    "--------- ------------------------------------------------

    let opts = {
                \ 'by'            : 'size' ,
                \ 'tabnr'         : tabpagenr() ,
                \ 'width_weight'  : s:golden_ratio       ,
                \ 'height_weight' : 1           ,
            \}
    if a:0 >= 1 && type(a:1) == type({})
        call extend(opts, a:1)
    endif

    let list = []
    for bufnr in tabpagebuflist(opts['tabnr'])
        let winnr  = bufwinnr(bufnr)
        let width  = winwidth(winnr)
        let height = winheight(winnr)
        let size   = width * opts['width_weight']
                 \ + height * opts['height_weight']

        call add(list, {
                    \ 'bufnr'  : bufnr  ,
                    \ 'winnr'  : winnr  ,
                    \ 'width'  : width  ,
                    \ 'height' : height ,
                    \ 'size'   : size   ,
                \ })
    endfor

    return GoldenView#zl#list#sort_by(list,'v:val["'.opts['by'].'"]')
endfunction


" ============================================================================
" Switch:                                                                 ⟨⟨⟨1
" ============================================================================

function! GoldenView#zl#window#switch_buffer_toggle(...)
    "--------- ------------------------------------------------
    " Desc    : toggle buffer switch
    "
    " Args    :
    "   - opts : >
    "   {
    "     'with'         : 'largest'              ,
    "   }
    "
    " Return  :
    " Raise   :
    "
    " Example : >
    "   nnoremap <silent> <C-@>
    "   \ :<C-u>call GoldenView#zl#window#switch_buffer_toggle()<CR>
    "--------- ------------------------------------------------

    let opts = {
                \ 'with'          : 'largest',
            \}
    if a:0 >= 1 && type(a:1) == type({})
        call extend(opts, a:1)
    endif

    let bufnr = bufnr('%')
    if exists('b:switch_buffer')
            \ && bufwinnr(b:switch_buffer['bufnr']) == b:switch_buffer['winnr']
        call GoldenView#zl#window#switch_buffer(bufnr, b:switch_buffer['bufnr'])
    else
        try
            let fn = 'GoldenView#zl#window#switch_buffer_with_'.opts['with']
            exec 'call ' . fn . '()'
        catch /^Vim%((a+))=:E700/
            throw "zl: function " . fn . 'for ' . opts['with']
                \ . ' is not implemented!'
        endtry

    endif
endfunction


function! GoldenView#zl#window#switch_buffer_with_sorted_by_size_index(index, ...)
    "--------- ------------------------------------------------
    " Desc    : switch buffer with the largest window
    "
    " Args    :
    "   - opts : >
    "   {
    "     'bufnr'         : bufnr('%')              ,
    "     'by'            : 'size'|'height'|'width' ,
    "     'tabnr'         : tabpagenr()             ,
    "     'width_weight'  : s:golden_ratio                   ,
    "     'height_weight' : 1                       ,
    "   }
    "
    " Return  :
    " Raise   :
    "
    " Example : >
    "   nnoremap <silent> <C-@>
    "   \ :<C-u>call GoldenView#zl#window#switch_buffer_with_largest()<CR>
    "--------- ------------------------------------------------


    let opts = {
                \ 'bufnr'         : bufnr('%')     ,
                \ 'by'            : 'size'         ,
                \ 'tabnr'         : tabpagenr()    ,
                \ 'width_weight'  : s:golden_ratio ,
                \ 'height_weight' : 1              ,
                \}
    if a:0 >= 1 && type(a:1) == type({})
        call extend(opts, a:1)
    endif

    let sorted = GoldenView#zl#window#sort_by(filter(copy(opts),'v:key != "bufnr"'))
    let bufnr_to = sorted[a:index]['bufnr']
    call GoldenView#zl#window#switch_buffer(opts['bufnr'], bufnr_to)
endfunction


function! GoldenView#zl#window#switch_buffer_with_largest(...)
    call GoldenView#zl#window#switch_buffer_with_sorted_by_size_index(-1, a:000)
endfunction

function! GoldenView#zl#window#switch_buffer_with_smallest(...)
    call GoldenView#zl#window#switch_buffer_with_sorted_by_size_index(0, a:000)
endfunction

function! GoldenView#zl#window#switch_buffer(bufnr1, bufnr2)
    "--------- ------------------------------------------------
    " Desc    : switch buffer window if both are visible
    "
    " Args    : bufnr1 <-> bufnr2
    " Return  :
    "   - 0 : fail
    "   - 1 : success
    " Raise   :
    "
    " Example : >
    "
    " Refer   :
    "--------- ------------------------------------------------
    let winnr1 = bufwinnr(a:bufnr1)
    let winnr2 = bufwinnr(a:bufnr2)
    if winnr1 != -1 && winnr2 != -1

        silent noautocmd exec winnr1 'wincmd w'
        if bufnr('%') != a:bufnr2
            silent noautocmd exec 'buffer' a:bufnr2
            let b:switch_buffer = {
                        \ 'bufnr' : a:bufnr1 ,
                        \ 'winnr' : winnr2   ,
                        \ }
        endif
        silent noautocmd exec winnr2 'wincmd w'
        if bufnr('%') != a:bufnr1
            silent noautocmd exec 'buffer' a:bufnr1

            " need filetype detect (maybe) because bufnr1 disappears for a
            " moment
            silent filetype detect

            let b:switch_buffer = {
                        \ 'bufnr' : a:bufnr2 ,
                        \ 'winnr' : winnr1   ,
                        \ }
        endif

        return 1
    else
        return 0
    endif
endfunction

function! GoldenView#zl#window#alternate_buffer()
    if bufnr('%') != bufnr('#') && buflisted(bufnr('#'))
        buffer #
    else
        let cnt = 0
        let pos = 1
        let current = 0
        while pos <= bufnr('$')
            if buflisted(pos)
                if pos == bufnr('%')
                    let current = cnt
                endif

                let cnt += 1
            endif

            let pos += 1
        endwhile

        if current > cnt / 2
            bprevious
        else
            bnext
        endif
    endif
endfunction

" ============================================================================
" Scroll:                                                                 ⟨⟨⟨1
" ============================================================================

function! GoldenView#zl#window#scroll_other_window(direction)
    execute 'wincmd' (winnr('#') == 0 ? 'w' : 'p')
    execute (a:direction ? "normal! \<C-d>" : "normal! \<C-u>")
    wincmd p
endfunction

" ============================================================================
" View:                                                                   ⟨⟨⟨1
" ============================================================================
function! GoldenView#zl#window#save_view_command(command) range
    let view = winsaveview()

    let range = ''
    if a:firstline != a:lastline
       let range = a:firstline.','.a:lastline
    endif
    try
        keepjumps execute range.a:command
    finally
        call winrestview(view)
    endtry
endfunction

" ============================================================================
" Modeline:                                                               ⟨⟨⟨1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=⟨⟨⟨,⟩⟩⟩ fdl=1 :

