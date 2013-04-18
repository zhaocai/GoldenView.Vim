# Always have a nice view for vim split windows

    ------------- - -----------------------------------------------
    Plugin        : GoldenView.vim
    Author        : Zhao Cai
    EMail         : caizhaoff@gmail.com
    URL           : http://zhaocai.github.io/GoldenView.Vim/
    Version       : 1.1.1
    Date Created  : Tue 18 Sep 2012 05:23:13 PM EDT
    Last Modified : Wed 17 Apr 2013 09:52:45 PM EDT
    ------------- - -----------------------------------------------



The initial motive for [GoldenView][GoldenView] comes from the frustration of using other vim plugins to autoresize split windows. The idea is deadly simple and very useful: **resize the focused window to a proper size.** However, in practice, many hiccups makes **autoresizing** not a smooth experience.  Below are a list of issues [GoldenView][GoldenView] attempts to solve:

First and the most important one, autoresizing should play nicely with existing plugins like `tagbar`, `vimfiler`, `unite`, `VOoM`, `quickfix`, `undotree`, `gundo`, etc. These windows should manage there own window size.

Second, autoresizing should take care of **the other windows** too. Resizing the focused window may cause the other windows become too small. When you have 4+ split windows, autoresizing may just make a mess out of it.


![GoldView Screencast]( http://dl.dropboxusercontent.com/u/1897501/Screencasts/GoldenView.gif )


## Features

[GoldenView][GoldenView] has preliminarily solved the issues described above. It also provides other features. Bascally, it does two things:

### 1. Autoresizing
First of all, it automatically resize the focused split window to a "golden" view based on [golden ratio][golden-ratio-wikipedia] and `textwidth`.


### 2. Tiled Windows Management
Second, it maps a single key (`<C-L>` by default) to nicely split windows to tiled windows. 
```
----+--------------+------------+---+
|   |              |            |   |
| F |              |    S1      | T |
| I |              +------------| A |
| L |  MAIN PANE   |    S2      | G |
| E |              +------------+ B |
| R |              |    S3      | A |
|   |              |            |   |
+---+--------------+------------+---+
```
To get this view, just hit `<C-L>` 4 times. or, if you have a large monitor, you may get tiled windows below.

```
----+--------------+--------------+------------+---+
|   |              |              |            |   |
| F |              |              |    S1      | T |
| I |              |              +------------| A |
| L |  MAIN PANE   |      M2      |    S2      | G |
| E |              |              +------------+ B |
| R |              |              |    S3      | A |
|   |              |              |            |   |
+---+--------------+--------------+------------+---+
```


To quickly switch between those windows, a few keys are mapped to 

- Focuse to the main window
- Switch with the largest, smallest, etc. 
- Jump to next and previous window





## Installation

Install [GoldenView][GoldenView] is the *same as installing other vim plugins*. If experienced with vim, you can skim the example below and move to [next section](#quick-start). 


### **Option A** - With [Plugin Manager][vim-plugin-manager] ( **recommanded** )

If you use plugin managers like *Pathogen*, *vundle*, *neobundle*, *vim-addon-manager*, etc., just unarchive the zip file or clone the [GoldenView][GoldenView] repo from `git://github.com/zhaocai/GoldenView.git` into your local plugin installation directory (most likely `~/.vim/bundle/`). Then add corresponding scripts in .vimrc for the bundle manager you are using.

**Example**:

- *neobundle*:

```vim
    NeoBundle 'zhaocai/GoldenView.Vim'
```

- *vundle*:

```vim
    Bundle 'zhaocai/GoldenView.Vim'
```

- *vim-addon-manager*:

```vim
    call vam#ActivateAddons(['GoldenView.Vim'], {'auto_install' : 1})
```


### **Option B** - Without [Plugin Manager][vim-plugin-manager]

Unarchive the zip file into a directory that is under `runtimepath` of your vim, `~/.vim` for example.


## Quick Start
[GoldenView][GoldenView] should work out of the box without configuration. It should automatically start to resize focused window to [golden ratio][golden-ratio-wikipedia] based on `textwidth` and vim available size. You may start to play with it now.

To get you started, a few default keys are mapped as below:

```vim 
" 1. split to tiled windows
nmap <silent> <C-L>  <Plug>GoldenViewSplit

" 2. quickly switch current window with the main pane
" and toggle back
nmap <silent> <F8>   <Plug>GoldenViewSwitchMain
nmap <silent> <S-F8> <Plug>GoldenViewSwitchToggle

" 3. jump to next and previous window
nmap <silent> <C-N>  <Plug>GoldenViewNext
nmap <silent> <C-P>  <Plug>GoldenViewPrevious

```

The meaning of those keys are self-explaining. A general workflow would be `<Plug>GoldenViewSplit` key to quickly and nicely split windows to the layout as below. Then you may open your files.

```
----+--------------+------------+---+
|   |              |            |   |
| F |              |    S1      | T |
| I |              +------------| A |
| L |  MAIN PANE   |    S2      | G |
| E |              +------------+ B |
| R |              |    S3      | A |
|   |              |            |   |
+---+--------------+------------+---+

```

To switch `S1` with `MAIN PANE`, in `S1` and hit `<Plug>GoldenViewSwitchMain`. To switch back, hit `<Plug>GoldenViewSwitchToggle` in either `MAIN PAIN` or `S1`

#### g:goldenview__enable_default_mapping

Every experienced vim user has a different set of key mappings. If you you are (most likely) unhappy about some of the mappings, map you own keys as below: 

```vim
let g:goldenview__enable_default_mapping = 0

nmap <silent> <MY_KEY> <Plug>GoldenViewSplit
" ... and so on

```

#### g:goldenview__enable_at_startup
if you do not want to start autoresizing automatically, you can put `let g:goldenview__enable_at_startup = 0` in your vimrc.


## More Usage - Commands and Mappings

1. `ToggleGoldenViewAutoResize`, `DisableGoldenViewAutoResize`, `EnableGoldenViewAutoResize`: These commands toggle, enable, and disable GoldenView autoresizing.

2. `GoldenViewResize` : this command do manual resizing of focused window. 
You can also map a key for this as below:

```vim 
nmap <silent> <YOUR_KEY> <Plug>GoldenViewResize

```

3. `SwitchGoldenViewLargest`, `SwitchGoldenViewSmallest`: these commands do as it named. 

You can also add mappings as below. ( no default keys for these mappings)
```vim 
nmap <silent> <YOUR_KEY> <Plug>GoldenViewSwitchWithLargest
nmap <silent> <YOUR_KEY> <Plug>GoldenViewSwitchWithSmallest

```

Other switch rules can be easily defined.


## More Customized Configuartion and Implementation Details  

> todo

 

## Issues:

If you have any issues, please post it to https://github.com/zhaocai/GoldenView.Vim/issues for discussion.


## Contributors




## RELEASE HISTORY

Refer to [History.md]( https://github.com/zhaocai/GoldenView.Vim/blob/master/History.md )

## LICENSE:

Copyright (c) 2013 Zhao Cai <caizhaoff@gmail.com>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.




[dwm]: http://www.vim.org/scripts/script.php?script_id=4186
[golden-ratio-plugin]: http://www.vim.org/scripts/script.php?script_id=3690
[golden-ratio-wikipedia]: http://en.wikipedia.org/wiki/Golden_ratio
[zl]: https://github.com/zhaocai/zl.vim "zl.vim vim script library"
[GoldenView]: https://github.com/zhaocai/GoldenView.Vim "GoldenView Vim Plugin"
[vim-plugin-manager]: http://vim-scripts.org/vim/tools.html "Vim Plugin Manangers"
