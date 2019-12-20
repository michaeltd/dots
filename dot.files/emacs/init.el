(load "~/.emacs.d/sanemacs.el" nil t)

;;; Your configuration goes below this line.
;;; use-package is already loaded and ready to go!
;;; use-package docs: https://github.com/jwiegley/use-package

;; all the icons
(require 'all-the-icons)
(use-package all-the-icons :ensure t)

;; dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)
;; Or if you use use-package
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; emacs --daemon
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

;; Set the title
(setq dashboard-banner-logo-title "Welcome to Emacs Dashboard")
;; Set the banner
(setq dashboard-startup-banner 'logo)
;; Value can be
;; 'official which displays the official emacs logo
;; 'logo which displays an alternative emacs logo
;; 1, 2 or 3 which displays one of the text banners
;; "path/to/your/image.png" which displays whatever image you would prefer

;; Content is not centered by default. To center, set
(setq dashboard-center-content t)

;; To disable shortcut "jump" indicators for each section, set
(setq dashboard-show-shortcuts nil)

;;To customize which widgets are displayed, you can use the following snippet

(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)))

;;To add icons to the widget headings and their items:

(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)

;;To modify heading icons with another icon from all-the-icons octicons:

(dashboard-modify-heading-icons '((recents . "file-text")
                                  (bookmarks . "book")))

;;To show navigator below the banner:

(setq dashboard-set-navigator t)

;; To customize the buttons of the navigator like this:
;; 
;; Format: "(icon title help action face prefix suffix)"
(setq dashboard-navigator-buttons
      `(;; line1
        ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
         "Homepage"
         "Browse homepage"
         (lambda (&rest _) (browse-url "homepage")))
        ("★" "Star" "Show stars" (lambda (&rest _) (show-stars)) warning)
        ("?" "" "?/h" #'show-help nil "<" ">"))
         ;; line 2
        ((,(all-the-icons-faicon "linkedin" :height 1.1 :v-adjust 0.0)
          "Linkedin"
          ""
          (lambda (&rest _) (browse-url "homepage")))
         ("⚑" nil "Show flags" (lambda (&rest _) (message "flag")) error))))

;; To show info about the packages loaded and the init time:

(setq dashboard-set-init-info t)
