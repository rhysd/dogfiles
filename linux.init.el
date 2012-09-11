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
(setq tex-command "latex2pdf")
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
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
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
(setq twittering-status-format "%i %s\n  %t\n")



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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
