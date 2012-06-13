; key-binding for activate uim (ex. C-\)
;(global-set-key "\C-\\" 'uim-mode)

;; lispディレクトリのパスの追加
(setq load-path (cons "~/.emacs.d/elisp" load-path))
(setq load-path (cons "~/.emacs.d/elisp/company" load-path))
(setq load-path (cons "~/.emacs.d/elisp/ruby" load-path))
(setq load-path (cons "~/.emacs.d/elisp/yatex" load-path))
(setq load-path (cons "~/.emacs.d/elisp/melpa" load-path))

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
;;(setq x-select-enable-clipboard t)

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
         '(width . 120)
         '(height . 56)
         '(top . 0)
         '(left . 0)
         '(alpha . (80 80 80 80))
;;         '(font . "Ricty-15")
         ; '(font . "Hiragino Mincho Pro-15")
         '(font . "Hiragino Kaku Gothic Pro-15")

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

;;スクロールバー
;;(set-scroll-bar-mode 'right) ;; 右側

;;; スクロールを一行ずつにする
(setq scroll-step 1)

;;; ツールバーを消す
;(tool-bar-mode 0)

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

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda () (inf-ruby-keys)))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; rubydb
(autoload 'rubydb "rubydb3x"
  "run rubydb on program file in buffer *gud-file*.
the directory containing file becomes the initial working directory
and source-file directory for your debugger." t)

;; rails
;;(defun try-complete-abbrev (old)
;;  (if (expand-abbrev) t nil))
;;(setq hippie-expand-try-functions-list
;;      '(try-complete-abbrev
;;        try-complete-file-name
;;        try-expand-dabbrev))
;;(require 'cl)

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)
;; ミニバッファに表示し, かつ, オーバレイする.
(setq ruby-block-highlight-toggle t)

;;company

;; ロード
(require 'auto-complete)
(require 'auto-complete-config)
;; 対象の全てで補完を有効にする
(global-auto-complete-mode t)
(require 'ac-company)
;; ac-company で company-gtags を有効にする
(ac-company-define-source ac-source-company-gtags company-gtags)
;; objc-mode, c-mode c++-mode で補完候補を設定
(setq ac-modes (append ac-modes '(c-mode)))
(setq ac-modes (append ac-modes '(c++-mode)))
;; hook
(add-hook 'c-mode-hook
          (lambda ()
            add-to-list 'ac-sources 'ac-source-company-gtags)
          )
;; 補完ウィンドウ内でのキー定義
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "TAB") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key ac-completing-map (kbd "M-/") 'ac-stop)
;; 補完が自動で起動するのを停止
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
(setq tex-command "/Users/rhayasd/.emacs.d/elisp/yatex/latex2pdf")
(setq dvi2-command "open -a Preview")

;;; anything.el
(require 'anything-config)
;; プレフィクスキー
(custom-set-variables '(anything-command-map-prefix-key "C-j"))
; (setq anything-command-map-prefix-key "C-j")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                              OS X の設定                              ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Command と option を切り替える(GUIのみ)
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

; クリップボード連携
; http://blog.lathi.net/articles/2007/11/07/sharing-the-mac-clipboard-with-emacs
(defun copy-from-osx ()
 (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
 (let ((process-connection-type nil))
     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
       (process-send-string proc text)
       (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)