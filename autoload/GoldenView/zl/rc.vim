" =============== ============================================================
" Description    : vim script library
" Author         : Zhao Cai <caizhaoff@gmail.com>
" HomePage       : https://github.com/zhaocai/zl.vim
" Date Created   : Mon 03 Sep 2012 09:05:14 AM EDT
" Last Modified  : Thu 18 Apr 2013 03:16:39 PM EDT
" Tag            : [ vim, library ]
" Copyright      : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" =============== ============================================================

" ============================================================================
" Initialization:                                                         [[[1
" ============================================================================

let s:GOLDENVIEW_ZL_VERSION_CURRENT = 130

let s:VERSION_FACTOR = str2float('0.01')


function! GoldenView#zl#rc#init() abort "                                            [[[2

    if v:version < 700
        echoerr "zl.vim: requires Vim >= 7"
        return
    endif

    if !exists("g:GoldenView_zl_force_reload")
        let g:GoldenView_zl_force_reload = 0
    endif

    if !exists("g:GoldenView_zl_debug_mode")
        let g:GoldenView_zl_debug_mode = 0
    endif

    let g:loaded_GoldenView_zl = s:GOLDENVIEW_ZL_VERSION_CURRENT * s:VERSION_FACTOR


endfunction



function! GoldenView#zl#rc#load_guard(prefix, vim_version, GoldenView_zl_version,exprs,...)    "[[[2
    "--------- ------------------------------------------------
    " Desc    : gereric script load guard function
    "
    " Args    :
    "   - prefix       : to generate loaded_var_name
    "   - vim_version  : minmium vim version requirement
    "   - GoldenView_zl_version : minmium zl.vim version requirement.
    "                    set 0 to ignore.
    "   - exprs        : assert list of expresses to be true
    "   - ... scope    : 'g' , 'b', ...
    "
    " Return  :
    "   - 1 : unloaded
    "   - 0 : already loaded
    "
    " Raise   :
    "
    " Example : >
    "   if !GoldenView#zl#rc#load_guard(expand('<sfile>:t:r'), 702, 100, ['!&cp'])
    "       finish
    "   endif
    "
    " Details :
    "   g:loaded_{script name} is defined as 1 if:
    "     - vim version > 702
    "     - zl version > 100
    "     - test !&cp is true
    "
    " Refer   :
    "--------- ------------------------------------------------

"   call Dfunc('GoldenView#zl#rc#load_guard(' . a:prefix .' '. a:vim_version .' '. a:GoldenView_zl_version .' '. join(a:exprs))

    let l:scope =  a:0 >= 1  ?  a:1  :  'g'

    let l:loaded_var_name = l:scope . ':loaded_'
                \ . substitute(a:prefix, '[^0-9a-zA-Z_]', '_', 'g')
"    call Decho("loaded_var_name: " . l:loaded_var_name)

    if exists(l:loaded_var_name) && g:GoldenView_zl_force_reload == 0
"       call Decho(l:loaded_var_name . ' loaded: return 0')
"       call Dret('GoldenView#zl#rc#load_guard')
        return 0
    endif

    if a:vim_version > 0 && a:vim_version > v:version
        echoerr l:loaded_var_name . ' requires Vim version '
                    \ . string(a:vim_version * s:VERSION_FACTOR)
        return 0
    elseif a:GoldenView_zl_version > 0
        if !exists("g:loaded_GoldenView_zl")
            echoerr 'zl.vim is required but not loaded'
            return 0
        endif

        if (a:GoldenView_zl_version > s:GOLDENVIEW_ZL_VERSION_CURRENT)
            echoerr l:loaded_var_name . ' requires zl library version '
                        \ . string(a:GoldenView_zl_version * s:VERSION_FACTOR)
            return 0
        endif
    endif
    for expr in a:exprs
        if !eval(expr)
            echoerr l:loaded_var_name . ' requires: ' . expr
"           call Dret('GoldenView#zl#rc#load_guard')
            return 0
        endif
    endfor
    let {l:loaded_var_name} = 1
"   call Dret('GoldenView#zl#rc#load_guard')
    return 1
endfunction

function! GoldenView#zl#rc#script_force_reload(...) " (script)                       [[[2
    "--------- ------------------------------------------------
    " Desc    : Call to ignore GoldenView#zl#rc#load_guard() and source.
    "
    " Args    : script path or current script by default
    " Return  :
    " Raise   : E484: cannot open file
    "
    "--------- ------------------------------------------------
    let script = a:0 >= 1 ? a:1 : '%'

    let l:saved = g:GoldenView_zl_force_reload
    let g:GoldenView_zl_force_reload = 1

    exec "so " . script

    let g:GoldenView_zl_force_reload = l:saved
endfunction











" ============================================================================
" Set Initialization Default Variables:                                   [[[1
" ============================================================================
function! GoldenView#zl#rc#set_default(var, ...) "  ('var', val) || ( {dict} )       [[[2
    "--------- ------------------------------------------------
    " Desc    : Set Initialization Default Variables
    "
    " Args    : ('var', val) || ( {dict} )
    " Return  :
    " Raise   : 'zl.vim ***'
    "
    " Pitfall : avoid 's:' variables, which will be defined in
    "           this rc.vim script bur your script
    "
    " Example : >
    "   call GoldenView#zl#rc#set_default({
    "             \ 'g:xxx_yyy'    : {
    "             \     'abc'        : 1,
    "             \ }
    "             \
    "             \ , 'g:yyy_zzz' : 'bcd'
    "         \ })
    "--------- ------------------------------------------------

    if type(a:var) == type({})
        for key in keys(a:var)
            call <SID>set_default(key, a:var[key])
        endfor
    elseif type(a:var) == type("")
        if a:0 >= 1
            call <SID>set_default(a:var, a:1)
        else
            throw "zl.vim should call with default value for " . a:var
        endif
    else
        throw "zl.vim unsupported type: " . type(a:var)
    endif
endfunction

function! s:set_default(var,val)
    if !exists(a:var) || type({a:var}) != type(a:val)
        let {a:var} = a:val
    endif
endfunction







call GoldenView#zl#rc#init()


" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=syntax fmr=[[[,]]] fdl=1 :
