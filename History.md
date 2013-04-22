# RELEASE HISTORY

## V1.3.0 / 2013-04-22

Diff Mode auto resizing (Zhao Cai <caizhaoff@gmail.com>)

Changes:

* 1 Major Enhancements

    * diff mode auto-resizing.

* 1 Minor Enhancements

    * refactor autocmd function: tweak restore behavior


## V1.2.2 / 2013-04-21

Improve documents and small bug fixes,
Load guard for #4 (github) (Zhao Cai <caizhaoff@gmail.com>)

Changes:

* 1 Minor Enhancements

    * better tracing

* 1 Bug Fixes

    * load guard for issue #4
      
      E806: using Float as a String


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


## HEAD / 2013-04-23

Current Development (Zhao Cai)


## V1.1.1 / 2013-04-18

improve documents, fix zl library load (Zhao Cai <caizhaoff@gmail.com>)


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

