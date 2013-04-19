# RELEASE HISTORY

## V1.2.0 / 2013-04-18

 (Zhao Cai <caizhaoff@gmail.com>)

Changes:

* 1 Major Enhancements

    * add restore rule for some special buffers

* 4 Bug Fixes

    * E36 no enough room to split
    * issue #2 MRU plugin window
    * init sequence
    * zl load guard


## V1.1.2 / 2013-04-18

Fix init sequence between zl.vim and GoldenVim (Zhao Cai <caizhaoff@gmail.com>)


## V1.1.1 / 2013-04-18

improve documents, fix zl library load (Zhao Cai <caizhaoff@gmail.com>)


## HEAD / 2013-04-19

Current Development (Zhao Cai)


## V1.1.0 / 2013-04-18

 (Zhao Cai <caizhaoff@gmail.com>)

Changes:

* 3 Major Enhancements

    * add WinLeave event into account. This version works perfectly.
    * fix various hiccups caused by winleave
    * use ignore rules from zl.vim

* 4 Minor Enhancements

    * add mapping to switch to main pane. [minor] speed up buffer switch with noautocmd
    * include zl.vim into source code
    * tune for autocmd sequence
    * treat winfixwidth and winfixheight separately

* 2 Bug Fixes

    * winleave cause ignored windows resized
    * cannot let &winminwidth > &winwidth

* 2 Nominal Changes

    * change profile variable scope to s:
    * tweak golden ratio for win size


## 1.0 / 2012-09-18

 (Zhao Cai <caizhaoff@gmail.com>)

