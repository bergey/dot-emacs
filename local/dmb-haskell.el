(add-to-list 'revert-without-query "~/.cabal/logs/*")
(add-to-list 'revert-without-query ".cabal-sandbox/logs/*")

(require 'haskell-mode-autoloads)

(use-package haskell-mode
  :mode "\\.hs\'"
  :mode "\\.lhs\'"
  :mode "\\.cabal\'"
  :init (progn
          (use-package ghc
            :commands ghc-init))
  :config
  (progn

    (setq haskell-mode-hook '(
                              ;;structured-haskell-mode
                              haskell-indentation-mode
                              whitespace-mode
                              flycheck-mode
                              subword-mode
                              interactive-haskell-mode ;; causes annoying project starts?
                              dmb-company-short-idle
                              smartparens-mode
                              (lambda ()
                                (setq-local helm-dash-docsets '("Haskell")))
                              haskell-auto-insert-module-template
                              ;; ghc-init  ; doesn't work with GHC-7.10?
                              ))

    (bind-keys :map haskell-mode-map
               ("M-C-h" . haskell-hoogle)
               ("C-," . haskell-move-nested-left)
               ("C-." . haskell-move-nested-right)
               ("C-c C-c" . haskell-compile)
               ("C-c v c" . haskell-cabal-visit-file)
               ;; haskell-process functions
               ("C-c C-l" . haskell-process-load-file)
               ("C-c C-z" . haskell-interactive-switch)
               ("C-c C-t" . haskell-process-do-type)
               ("C-c C-i" . haskell-process-do-info)
               ("C-c C-c" . haskell-process-cabal-build)
               ;; ("C-c C-k" . haskell-interactive-mode-clear)
               ("C-c c" . haskell-process-cabal)
               ("SPC" . haskell-mode-contextual-space)
               ("C-c i" . haskell-navigate-imports))

    (setq haskell-tags-on-save t
          haskell-stylish-on-save t
          haskell-ask-also-kill-buffers nil
          haskell-process-type 'stack-ghci
          )))

(use-package haskell-interactive-mode
  :commands interactive-haskell-mode
  ;; :diminish interactive-haskell-mode
  :config
  (progn

    ;; TODO this isn't the .hs file map, and <up>, <down> wouldn't
    ;; make sense if it were

    ;; source code buffer
    (bind-keys :map haskell-interactive-mode-map
               ("C-c C-n" . haskell-interactive-mode-error-forward)
               ("C-c C-p" . haskell-interactive-mode-error-backward)
               ("<up>" . haskell-interactive-mode-history-previous)
               ("<down>" . haskell-interactive-mode-history-next)
               )

    (bind-keys :map  haskell-interactive-mode-map
               ;; ghci buffer
               ("<up>" . haskell-interactive-mode-history-previous)
               ("<down>" . haskell-interactive-mode-history-next))

    (setq haskell-process-suggest-remove-import-lines t
          haskell-process-auto-import-loaded-modules t
          haskell-process-suggest-hoogle-imports t
          haskell-process-log t
          haskell-process-auto-import-loaded-modules t)))


;; structured-haskell-mode
(use-package shm
  :commands structured-haskell-mode
  :config
  (progn
    (define-key shm-map (kbd "M-{") nil)
    (define-key shm-map (kbd "M-}") nil)
    (define-key shm-map (kbd "RET") 'shm/newline-indent)
    (define-key shm-map (kbd "C-j") 'shm/simple-indent-newline-same-col)))

(provide 'dmb-haskell)
