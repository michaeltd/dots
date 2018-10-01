# <p align="center">tdm dots</p>
<p align="center"><a href="http://www.tldp.org/LDP/abs/html/abs-guide.html"><img alt="bash-logo" src="assets/bash-logo.png"></a></p>
<p align="center"><a href="http://unmaintained.tech/"><img alt="No Maintenance Intended" src="http://unmaintained.tech/badge.svg"></a> <a href="https://opensource.org/licenses/MIT"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a></p>

  Possible usage: "git clone https://github.com/MichaelTd/dots" then go through the contents of this repo and select what suits your own needs so you can incorporate exactly that in your working environment. Verbatim use of this repo is discouraged.

## [dot.files](dot.files)

* [Shell](dot.files/.bash_profile), [X setup](dot.files/.xinitrc), [bin](dot.files/bin/), [sbin (maintenance scripts)](dot.files/sbin/)

  * [.bashrc.d](dot.files/.bashrc.d) functions as a interactive shell initialization routine and it's customizations of [Durag](http://dotshare.it/~Durag/)'s [Improved Terminal](http://dotshare.it/dots/1027/) at [http://dotshare.it/](http://dotshare.it/) and a prompt from [mathiasbynens](https://github.com/mathiasbynens/dotfiles)

  * [wallpaper-rotate.sh](dot.files/bin/wallpaper-rotate.sh)
  Script for rolling random images as wallpapers.

  <p align="center"><a href="dot.files/bin/wallpaper-rotate.sh"><img alt="Help screen" src="assets/wpr.png"></a></p>

  * [upgrade-distro.sh](dot.files/sbin/upgrade-distro.sh)
  Distro neutral upgrade script (and bash arrays mini crash course).


* Some WM's (in no particular order)
   * [Window Maker](dot.files/GNUstep/)
   * [e16](dot.files/.e16/)
   * [openbox](dot.files/.config/openbox/)
   * [awesome](dot.files/.config/awesome/)
   * [Compiz](dot.files/.config/compiz/)
   * [Motif WM](dot.files/.mwmrc)


* Editors, [Utilities](dot.files/.tmux.conf).

   - If emacs is "your thing", check one of ...

     - https://github.com/technomancy/emacs-starter-kit
     - https://github.com/bbatsov/prelude
     - My setup consists of [a reasonable emacs config](https://github.com/purcell/emacs.d) and a special dashboard [splashscreen](https://github.com/notarock/.emacs.d/blob/master/splash.png)

  - If vim is what makes you "tick", check out [SpaceVim](https://github.com/SpaceVim/SpaceVim), a well maintained vim distribution.

#### [bootstrap.sh](bootstrap.sh)
How I migrate my .dots in new systems. Don's use this unless you are fully aware of the ramifications of the situation you put your self into.

## Reference
#### [GitHub ❤ ~/](https://dotfiles.github.io/)
Your unofficial guide to dotfiles on GitHub.

#### [Advanced Bash Scripting Guide](http://www.tldp.org/LDP/abs/html/abs-guide.html) ([PDF](http://www.tldp.org/LDP/abs/abs-guide.pdf))
The Bash all in one goto place.

#### [EbookFoundation free-programming-books - bash](https://github.com/EbookFoundation/free-programming-books/blob/master/free-programming-books.md#bash)
Free books relevant to bash (and much more).

#### [bash-oo-framework](https://github.com/niieani/bash-oo-framework) https://github.com/niieani/bash-oo-framework
OO bash framework.

#### [bash-hackers](http://wiki.bash-hackers.org/) http://wiki.bash-hackers.org/
See what other fellow bash'ers are up to.
