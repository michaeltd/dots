# <p align="center">mick's dots</p>
<p align="center"><a href="http://www.tldp.org/LDP/abs/html/abs-guide.html"><img alt="bash-logo" src="assets/bash_logo_transparent.svg"></a></p>
<p align="center"><a href="http://unmaintained.tech/"><img alt="No Maintenance Intended" src="http://unmaintained.tech/badge.svg"></a> <a href="https://opensource.org/licenses/MIT"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a></p>

  Possible use: "git clone https://github.com/MichaelTd/dots", go through the this repository and select what fits your needs so you can incorporate it in your working environment.

  My dots tend to be opinionated so take them with a grain of rice ...err SALT, I meant salt. Take them with a grain of salt.

## [dot.files](dot.files)

* [Shell](dot.files/.bash_profile), [X setup](dot.files/.xinitrc), [bin](dot.files/bin/), [sbin (maintenance scripts)](dot.files/sbin/)

  * [.bashrc.d](dot.files/.bashrc.d)
  <br/>Is a interactive shell initialization routine and it is customization of [Durag](http://dotshare.it/~Durag/)'s [Improved Terminal](http://dotshare.it/dots/1027/) at [http://dotshare.it/](http://dotshare.it/) with a prompt from [mathiasbynens](https://github.com/mathiasbynens/dotfiles)

  * [wallpaper-rotate.sh](dot.files/bin/wallpaper-rotate.sh)
  <br/>Script for rolling random images as wallpapers.
  <br/>I get my wallpapers from: [r/EarthPorn](https://www.reddit.com/r/EarthPorn/), [unsplash.com](https://unsplash.com/), [space.com](https://www.space.com/wallpapers), [wallup.net](https://wallup.net/), [wallpaperscraft.com](https://wallpaperscraft.com/)

  <p align="center"><a href="dot.files/bin/wallpaper-rotate.sh"><img alt="Help screen" src="assets/wpr.png"></a></p>

  * [upgrade-distro.sh](dot.files/sbin/upgrade-distro.sh)
  <br/>Distro neutral upgrade script.


* Some WM's (in no particular order)

  * [wmaker](dot.files/GNUstep/)

  <p align="center"><a href="dot.files/GNUstep/"><img width="200" alt="Window Maker" src="assets/wmaker.png"></a></p>

  * [e16](dot.files/.e16/)

  <p align="center"><a href="dot.files/.e16/"><img width="200" alt="e16" src="assets/e16.png"></a></p>

  * [openbox](dot.files/.config/openbox/)

  <p align="center"><a href="dot.files/.config/openbox/"><img width="200" alt="openbox" src="assets/openbox.png"></a></p>

  * [awesome](dot.files/.config/awesome/)

  <p align="center"><a href="dot.files/.config/awesome/"><img width="200" alt="awesome" src="assets/awesome.png"></a></p>

  * [compiz](dot.files/.config/compiz/)

  <p align="center"><a href="dot.files/.config/compiz/"><img width="200" alt="compiz" src="assets/compiz.png"></a></p>

  * [mwm](dot.files/.mwmrc)

  <p align="center"><a href="dot.files/.mwmrc"><img width="200" alt="Motif WM" src="assets/mwm.png"></a></p>

  * [exwm](https://github.com/ch11ng/exwm/wiki) (cause reasons...)

  <p align="center"><a href="https://github.com/ch11ng/exwm/wiki"><img width="200" alt="emacs(exwm)" src="assets/exwm.png"></a></p>


 * Editors, [Utilities](dot.files/.tmux.conf).

   * If emacs is your "thing", check one of ...

     * https://github.com/technomancy/emacs-starter-kit
     * https://github.com/bbatsov/prelude
     * My setup consists of [a reasonable emacs config](https://github.com/purcell/emacs.d) and a [splashscreen](https://github.com/notarock/.emacs.d/blob/master/splash.png).

   * If vim is what makes you "tick", check out [SpaceVim](https://github.com/SpaceVim/SpaceVim), a community maintained vim distribution.

<a name="bootstrap.sh"></a>
#### [bootstrap.sh](bootstrap.sh)
How I migrate my .dots in new systems. Don't use this unless you know exactly what you're getting into.

## Reference
#### [GitHub ❤ ~/](https://dotfiles.github.io/)
Your unofficial guide to dotfiles on GitHub.

#### [Advanced Bash Scripting Guide](http://www.tldp.org/LDP/abs/html/abs-guide.html) ([PDF](http://www.tldp.org/LDP/abs/abs-guide.pdf))
The Bash all in one goto place.

#### [EbookFoundation free-programming-books - bash](https://github.com/EbookFoundation/free-programming-books/blob/master/free-programming-books.md#bash)
Free books relevant to bash (and much more).

#### [bash-hackers wiki](http://wiki.bash-hackers.org/)
See what other fellow bash'ers are up to.
