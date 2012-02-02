;; lispディレクトリのパスの追加
(setq load-path (cons "~/.emacs.d/site-lisp" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/ruby" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/company" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/yatex" load-path))

;; デフォルトの透明度を設定する (80%)
(add-to-list 'default-frame-alist '(alpha . 80))

;;タブ幅を 2 に設定
(setq-default tab-width 2)
;;タブ幅の倍数を設定
(setq tab-stop-list
  '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;; 起動時のサイズ,表示位置,フォントを指定
(setq default-frame-alist
      (append (list
         '(width . 120)
         '(height . 40)
         '(top . 0)
         '(left . 0)
         ;;'(alpha . (70 50 50 30))
         ;;'(font . "Monospace-11")
         '(font . "Ricty-11")
         )
              default-frame-alist))

(if window-system (progn

  ;; 文字の色を設定します。
  (add-to-list 'default-frame-alist '(foreground-color . "white"))
  ;; 背景色を設定します。
  (add-to-list 'default-frame-alist '(background-color . "black"))
  ;; カーソルの色を設定します。
  (add-to-list 'default-frame-alist '(cursor-color . "white"))
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
(set-scroll-bar-mode 'right) ;; 右側

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

;;行番号を表示(linum.el)
(require 'linum)
(global-linum-mode)

;;C-hをバックスペースに割り当てる
(global-set-key "\C-h" 'delete-backward-char)

;;C-x h をヘルプに割り当てる
;;; overrides mark-whole-buffer
(global-set-key "\C-xh" 'help-command)


;;twittering-mode
;;(add-to-list 'load-path "~/.emacs.d/elisp")
;;(require 'twittering-mode)
;;(setq twittering-username "Linda_PlusPlus")
;;(setq twittering-password "Se90i1sB6e2")

;;encordingをutf-8に
(set-terminal-coding-system 'euc-japan)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)


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
;(defun try-complete-abbrev (old)
;  (if (expand-abbrev) t nil))
;(setq hippie-expand-try-functions-list
;      '(try-complete-abbrev
;        try-complete-file-name
;        try-expand-dabbrev))
;(setq rails-use-mongrel t)
;(require 'cl)
;(require 'rails)

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
(setq ac-auto-start nil)
;; 起動キーの設定
(ac-set-trigger-key "TAB")
;; 候補の最大件数 デフォルトは 10件
(setq ac-candidate-max 20)

;;yatex
;(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;(setq load-path (cons "/usr/share/emacs23/site-lisp/yatex" load-path))
;(modify-coding-system-alist 'file "\\.tex$" 'euc-jp)
;; 従来どおりのキーマップを使う
;(setq YaTeX-inhibit-prefix-letter nil)
;(setq auto-mode-alist
;      (append '(("\\.tex$" . yatex-mode)
;                ("\\.ltx$" . yatex-mode)
;                ("\\.cls$" . yatex-mode)
;                ("\\.sty$" . yatex-mode)
;                ("\\.clo$" . yatex-mode)
;                ("\\.bbl$" . yatex-mode)) auto-mode-alist)
;)

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
(setq YaTeX-kanji-code 3);;; YaTeX
(setq tex-command "platex")
(setq dvi2-command "xdvi")

;; orgモード
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(add-hook 'org-mode-hook 'turn-on-font-lock)
