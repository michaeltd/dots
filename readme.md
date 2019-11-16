# <p align="center">michaeltd dots</p>
<p align="center"><a href="http://www.tldp.org/LDP/abs/html/abs-guide.html"><img alt="bash-logo" src="assets/bash_logo_transparent.svg"></a></p>
<p align="center"><a href="http://unmaintained.tech/"><img alt="No Maintenance Intended" src="http://unmaintained.tech/badge.svg"></a> <a href="https://opensource.org/licenses/MIT"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a></p>

  Possible use: "git clone https://github.com/michaeltd/dots", go through this repository and select what fits your needs so you can incorporate it in your working environment.

  My dots tend to be opinionated so take them with a grain of rice ...err SALT, I meant salt. Take them with a grain of salt.

## [dot.files](dot.files)

* [Shell](dot.files/.bash_profile), [X setup](dot.files/.xinitrc), [bin](dot.files/bin/), [sbin (maintenance scripts)](dot.files/sbin/)

  * [.bashrc.d](dot.files/.bashrc.d)
  <br/>Is a interactive shell initialization routine and it is customization of [Durag](http://dotshare.it/~Durag/)'s [Improved Terminal](http://dotshare.it/dots/1027/) at [http://dotshare.it/](http://dotshare.it/) with a prompt from [mathiasbynens](https://github.com/mathiasbynens/dotfiles)

  * [upgrade_distro.sh](dot.files/sbin/upgrade_distro.sh)
  <br/>Distro neutral upgrade script

  * [update_bkps.sh](dot.files/sbin/update_bkps.sh)
  <br/>Back up things ...

  * [cleanup_bkps.sh](dot.files/sbin/cleanup_bkps.sh)
  <br/> ... and clean up the mess.

  * [wallpaper_rotate.sh](dot.files/bin/wallpaper_rotate.sh)
  <br/>Script for rolling random images as wallpapers.
  <br/>I get my wallpapers from: [r/spaceporn](https://www.reddit.com/r/spaceporn), [r/earthporn](https://www.reddit.com/r/earthporn/), [r/unixporn](https://www.reddit.com/r/unixporn), [r/wallpapers](https://www.reddit.com/r/wallpapers)

  <p align="center"><a href="dot.files/bin/wallpaper_rotate.sh"><img alt="Help screen" src="assets/wpr.png"></a></p>

* Some WM's in no particular order.

  * [wmaker](dot.files/GNUstep/), [website](https://www.windowmaker.org/)
    
  <p align="center"><a href="https://en.wikipedia.org/wiki/Window_Maker"><img width="200" alt="Window Maker" src="assets/wmaker.png"></a></p>

  * [e16](dot.files/.e16/), [website](https://www.enlightenment.org/e16)

  <p align="center"><a href="https://en.wikipedia.org/wiki/Enlightenment_(software)#E16"><img width="200" alt="e16" src="assets/e16.png"></a></p>

  * [openbox](dot.files/.config/openbox/), [website](http://openbox.org/)

  <p align="center"><a href="https://en.wikipedia.org/wiki/Openbox"><img width="200" alt="openbox" src="assets/openbox.png"></a></p>

  * [awesome](dot.files/.config/awesome/), [website](https://awesomewm.org/)

  <p align="center"><a href="https://en.wikipedia.org/wiki/Awesome_(window_manager)"><img width="200" alt="awesome" src="assets/awesome.png"></a></p>

  * [compiz](dot.files/.config/compiz/), [website](https://launchpad.net/compiz)

  <p align="center"><a href="https://en.wikipedia.org/wiki/Compiz"><img width="200" alt="compiz" src="assets/compiz.png"></a></p>

  * [mwm](dot.files/.mwmrc), [website](https://motif.ics.com/)

  <p align="center"><a href="https://en.wikipedia.org/wiki/Motif_Window_Manager"><img width="200" alt="Motif WM" src="assets/mwm.png"></a></p>

  * [exwm](dot.files/.xinitrc#L69), [website](https://github.com/ch11ng/exwm/wiki)

  <p align="center"><a href="https://en.wikipedia.org/wiki/GNU_Emacs"><img width="200" alt="emacs(exwm)" src="assets/exwm.png"></a></p>


 * Editors, [Utilities](dot.files/.tmux.conf).

   * If emacs is your "thing", check one of ...

     * [emacs-starter-kit](https://github.com/technomancy/emacs-starter-kit)
     * [prelude](https://github.com/bbatsov/prelude)
     * [a reasonable emacs config](https://github.com/purcell/emacs.d)
     
     My setup consists of [Centaur Emacs](https://github.com/seagle0128/.emacs.d) and a [splashscreen](assets/gnu.png).

   * If vim is what makes you "tick", check out [SpaceVim](https://github.com/SpaceVim/SpaceVim), a community maintained vim distribution.

<a name="bootstrap.sh"></a>
#### [bootstrap.sh](bootstrap.sh)
How I migrate my .dots in new systems. Don't use this unless you know exactly what you're getting into.

## Reference
#### [GitHub ❤ ~/](https://dotfiles.github.io/)
Your unofficial guide to dotfiles on GitHub.

#### [Awesome Bash](https://github.com/awesome-lists/awesome-bash) [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)
A curated list of delightful Bash scripts and resources.

#### [EbookFoundation free-programming-books - bash](https://github.com/EbookFoundation/free-programming-books/blob/master/free-programming-books.md#bash)
Free books relevant to bash (and much more).

#### [bash-hackers wiki](http://wiki.bash-hackers.org/)
See what other fellow bash'ers are up to.

#### [Advanced Bash Scripting Guide](http://www.tldp.org/LDP/abs/html/abs-guide.html) ([PDF](http://www.tldp.org/LDP/abs/abs-guide.pdf))
The Bash all in one goto place.

