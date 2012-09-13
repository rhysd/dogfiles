; key-binding for activate uim (ex. C-\)
;(global-set-key "\C-\\" 'uim-mode)

; lispディレクトリのパスの追加
(setq load-path (cons "~/.emacs.d/elisp/yatex" load-path))

(require 'package)
; Add package-archives
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

; Initialize
(package-initialize)

; melpa.el
(require 'melpa)

;; C+/ にundoを割り当てる
;;(global-set-key "\C-/" 'advertised-undo)

;; encoding UTF-8 (MacOS X)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; clipboardを共有する
(setq x-select-enable-clipboard t)

;;タブ幅を 4 に設定
(setq-default tab-width 4)
;;タブ幅の倍数を設定
(setq tab-stop-list
  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;; 起動時のサイズ,表示位置,フォントを指定
(setq default-frame-alist
      (append (list
         '(alpha . (80 80 80 80))
         '(font . "Ricty-15")
         ; '(font . "Hiragino Mincho Pro-15")
;;         '(font . "Hiragino Kaku Gothic Pro-15")

         )
              default-frame-alist))

(if window-system (progn

  ;; 文字の色を設定します。
  (add-to-list 'default-frame-alist '(foreground-color . "white smoke"))
  ;; 背景色を設定します。
  (add-to-list 'default-frame-alist '(background-color . "black"))
  ;; カーソルの色を設定します。
  (add-to-list 'default-frame-alist '(cursor-color . "white smoke"))
  ;; マウスポインタの色を設定します。
  ;;(add-to-list 'default-frame-alist '(mouse-color . "SlateBlue2"))
  ;; モードラインの文字の色を設定します。
  ;;(set-face-foreground 'modeline "white")
  ;; モードラインの背景色を設定します。
  ;;(set-face-background 'modeline "MediumPurple2")
  ;; 選択中のリージョンの色を設定します。
  ;;(set-face-background 'region "LightSteelBlue1")
  ;; モードライン（アクティブでないバッファ）の文字色を設定します。
  (set-face-foreground 'mode-line-inactive "gray30")
  ;; モードライン（アクティブでないバッファ）の背景色を設定します。
  (set-face-background 'mode-line-inactive "gray85")

))

;; カラーテーマ設定
(load-theme 'wombat t)

;;スクロールバー
(set-scroll-bar-mode nil)

;;; スクロールを一行ずつにする
(setq scroll-step 1)

;;; ツールバーを消す
(tool-bar-mode 0)

;;;メニューバーを消す
(menu-bar-mode 0)

;; 起動時の画面はいらない
(setq inhibit-startup-message t)

;;言語を日本語に設定
(set-language-environment "Japanese")

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;;行番号を表示
;;(require 'linum)
(global-linum-mode)

;;C-hをバックスペースに割り当てる
(global-set-key "\C-h" 'delete-backward-char)

;;C-x h をヘルプに割り当てる
;;; overrides mark-whole-buffer
(global-set-key "\C-xh" 'help-command)

;;改行
(add-hook 'c-mode-common-hook
          '(lambda ()
             ;; RET キーで自動改行+インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
             ;; センテンスの終了である ';' を入力したら、自動改行+インデント
             ;;(c-toggle-auto-hungry-state 1)
             (c-set-style "stroustrup")
             (setq c-basic-offset 2)
             ;; C-c c で compile コマンドを呼び出す
             (define-key mode-specific-map "c" 'compile)
             ))

;; 全自動インデントを有効
;;(setq c-auto-newline t)
;; [TAB］キーでインデント実施
(setq c-tab-always-indent t)

;; 半ページスクロール
(define-key global-map (kbd "M-n")
  '(lambda () (interactive) (scroll-up (/ (window-height) 2))))
(define-key global-map (kbd "M-p")
  '(lambda () (interactive) (scroll-down (/ (window-height) 2))))

;; symlink でも開く
(setq vc-follow-symlinks t)

;; ミニバッファに入ると自動で IM OFF
;; (defvar *ime-mode-into-minibuffer* nil)

;; (defun ime-state-get-and-setoff (bef-buffer file-name)
;;  (interactive)
;;  (setq *ime-mode-into-minibuffer* (get-ime-mode)
;;   )
;;  (toggle-ime nil)
;;   )

;; (defun ime-state-set (bef-buffer file-name)
;;  (interactive)
;;  (toggle-ime *ime-mode-into-minibuffer*
;;   )
;;   )

;; (add-hook '*enter-minibuffer-hook* 'ime-state-get-and-setoff)
;; (add-hook '*exit-minibuffer-hook* 'ime-state-set)



;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
;; 対象の全てで補完を有効にする
(global-auto-complete-mode t)
;; 補完が自動で起動する
(setq ac-auto-start t)
;; 起動キーの設定
(ac-set-trigger-key "TAB")
;; 候補の最大件数 デフォルトは 10件
(setq ac-candidate-max 20)

;;; YaTeX
;; yatex-mode の起動
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;; 文章作成時の日本語文字コード
;; 0: no-converion
;; 1: Shift JIS (windows & dos default)
;; 2: ISO-2022-JP (other default)
;; 3: EUC
;; 4: UTF-8
(setq YaTeX-kanji-code 4);;; YaTeX
(setq tex-command "platex")
(setq dvi2-command "apvlv")

;;; anything.el
(require 'anything)
(require 'anything-config)
;; プレフィクスキー
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#fdf6e3" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(ansi-term-color-vector [unspecific "#586e75" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#002b36"])
 '(anything-command-map-prefix-key "C-j")
 '(custom-safe-themes (quote ("93815fc47d9324a7761b56754bc46cd8b8544a60fca513e634dfa16b8c761400" "6cfe5b2f818c7b52723f3e121d1157cf9d95ed8923dbc1b47f392da80ef7495d" "6615e5aefae7d222a0c252c81aac52c4efb2218d35dfbb93c023c4b94d3fa0db" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(fci-rule-color "#eee8d5"))
(setq anything-command-map-prefix-key "C-j")
;; 各anythingソース呼び出し割り当て
(global-set-key "\C-ja" 'anything)
(global-set-key "\C-jf" 'anything-find-file)
(global-set-key "\C-jl" 'anything-locate)
(global-set-key "\C-ji" 'anything-imenu)
(global-set-key "\C-jb" 'anything-buffers+)
(global-set-key "\C-jr" 'anything-recentf)
;; ソース間移動
(define-key anything-map "\M-p" 'anything-previous-source)
(define-key anything-map "\M-n" 'anything-next-source)

;; twittering-mode
(require 'twittering-mode)
(setq twittering-private-info-file "~/.emacs.d/twittering-mode.gpg")
(setq twittering-use-master-password t)
(setq twittering-icon-mode t)
(setq twittering-timer-interval 30)
(setq twittering-status-format "%i %s %@ from %f\n  %t\n")


;; flymake 
(require 'flymake)
 ;; latex 
(defun flymake-tex-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-dir   (file-name-directory buffer-file-name))
         (local-file  (file-relative-name
                       temp-file
                       local-dir)))
    (list "platex" (list "-file-line-error" "-interaction=nonstopmode" local-file))))
(defun flymake-tex-cleanup-custom ()
  (let* ((base-file-name (file-name-sans-extension (file-name-nondirectory flymake-temp-source-file-name)))
          (regexp-base-file-name (concat "^" base-file-name "\\.")))
    (mapcar '(lambda (filename)
                      (when (string-match regexp-base-file-name filename)
                         (flymake-safe-delete-file filename)))
                (split-string (shell-command-to-string "ls"))))
  (setq flymake-last-change-time nil))
(push '("\\.tex$" flymake-tex-init flymake-tex-cleanup-custom) flymake-allowed-file-name-masks)
(add-hook 'yatex-mode-hook 'flymake-mode-1)


(defun flymake-mode-1 ()
  (if (not (null buffer-file-name)) (flymake-mode))
  (local-set-key "\C-cd" 'flymake-display-err-minibuf))

(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info (flymake-current-line-no))))
         (count (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                              OS X の設定                              ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Command と option を切り替える(GUIのみ)
;; (setq ns-command-modifier (quote meta))
;; (setq ns-alternate-modifier (quote super))

;; ; クリップボード連携
;; ; http://blog.lathi.net/articles/2007/11/07/sharing-the-mac-clipboard-with-emacs
;; (defun copy-from-osx ()
;;  (shell-command-to-string "pbpaste"))

;; (defun paste-to-osx (text &optional push)
;;  (let ((process-connection-type nil))
;;      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;;        (process-send-string proc text)
;;        (process-send-eof proc))))

;; (setq interprogram-cut-function 'paste-to-osx)
;; (setq interprogram-paste-function 'copy-from-osx)
