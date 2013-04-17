# Always have a nice view for vim split windows

    ------------- - ----------------------------------------------------------
    Plugin        : GoldenView.vim
    Author        : Zhao Cai
    EMail         : caizhaoff@gmail.com
    URL           : https://github.com/zhaocai/GoldenView.vim
    Date Created  : Tue 18 Sep 2012 05:23:13 PM EDT
    Last Modified : Thu 27 Sep 2012 01:23:25 AM EDT
    ------------- - ----------------------------------------------------------

## :
1. play nicely with existing plugins like `tagbar`, `vimfiler`, `unite`, `VOoM`, etc. 
2. make other window too small

[GoldenView][GoldenView] is a window manager split windows. It does three things:





First of all, it automatically resize the focused split window to a "golden" view based on [golden ratio][golden-ratio-wikipedia] and `textwidth`.

Second, it helps to quickly split windows to

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |              |        S1        |
    |              |===================
    |      V       |        S2        |
    |              |===================
    |              |        S3        |
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

or, (if you have a large monitor)

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |              |              |        S1        |
    |              |              |===================
    |      V1      |      V2      |        S2        |
    |              |              |===================
    |              |              |        S3        |
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

with single key mapping (`<C-L>` by default).



Third, it maps keys to switch with the largest, smallest, etc. split window.





## Installation

Latest version: https://github.com/zhaocai/GoldenView.Vim

Install [GoldenView][GoldenView] is the *same as installing other vim plugins*.
If experienced with vim, you can skim the example below and move to the [next section](#Interface). 


### **Option A** - With [Plugin Manager][vim-plugin-manager] ( **recommanded** )

If you use plugin managers like *Pathogen*, *vundle*,
*neobundle*, *vim-addon-manager*, etc., just unarchive the zip file or clone the
[GoldenView][GoldenView] repo from
`git://github.com/zhaocai/GoldenView.git` into your local plugin installation directory
(most likely `~/.vim/bundle/`). Then add corresponding command in .vimrc for the
bundle manager you are using.


**Example**:

1. *neobundle*:

```vim
    NeoBundle 'zhaocai/GoldenView.Vim'
```

2. *vundle*:

```vim
    Bundle 'zhaocai/GoldenView.Vim'
```


3. *vim-addon-manager*:

```vim
    call vam#ActivateAddons(['GoldenView.Vim'], {'auto_install' : 0})
```


### **Option B** - Without [Plugin Manager][vim-plugin-manager]

After you install [zl.vim][zl], unarchive the zip file into a directory
that is under `runtimepath` of your vim, including ~/.vim dir.


## Interface

### Command 
### Key Mapping
### Variable 

## Usage

    :


## Contributors


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
