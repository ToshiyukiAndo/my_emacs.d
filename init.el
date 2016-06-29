;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ------------------------------------------------------------------------
;; @ load-path


;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))



;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp")

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;;------------------------------general---------------------------------

;;対応する括弧の強調表示
(show-paren-mode t)
;;時間表時
(display-time)
(put 'upcase-region 'disabled nil)
;;C-zをアンドゥに変更
(define-key global-map(kbd"C-z")'undo)
;;C-wをコピーに
(global-set-key "\C-w" "\M-w")

;;スクロール一行ずつ
(setq scroll-step 1)

;; 文字コード
(prefer-coding-system 'utf-8-unix)


;; common lisp
(require 'cl)

(let ((ws window-system))
  (cond ((eq ws 'w32)
	 (set-face-attribute 'default nil
			     :family "Meiryo"  ;; 英数
			     :height 100)
	 (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Meiryo")))  ;; 日本語
	((eq ws 'ns)
	 (set-face-attribute 'default nil
			     :family "Ricty"  ;; 英数
			     :height 140)
	 (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Ricty")))))  ;; 日本語

;; スタートアップ非表示
(setq inhibit-startup-screen t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; ツールバー非表示
(tool-bar-mode -1)

;; メニューバーを非表示
(menu-bar-mode -1)

;; スクロールバー非表示
(set-scroll-bar-mode nil)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
            (format "%%f - Emacs@%s" (system-name)))

;; 行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
		    :foreground "#808080"
		    :height 0.9)

;;キー移動を5行づつするやつ
(define-key global-map "\C-l" (kbd "C-u 5 C-n"))
(define-key global-map "\C-o" (kbd "C-u 5 C-p"))

;;ページ送り上を改善
(define-key global-map "\C-t" (kbd "M-v"))

;;backspace
(define-key global-map "\C-h" 'delete-backward-char)

;;emacs-zoneの設定
;;(setq zone-timer (run-with-idle-timer 120 t 'zone))

;;emacs, twitter
;;(require 'twittering-mode)

;; 括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#696969")

;; 選択領域の色
(set-face-background 'region "#d3d3d3")

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; タブ幅
(custom-set-variables '(tab-width 4))

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;;バックアップファイルを作らない
(setq backup-inhibited t)

;;カラーテーマ
(load-theme 'manoj-dark t)

;; redoできるようにする
;; http://www.emacswiki.org/emacs/redo+.el
(when (require 'redo+ nil t)
    (define-key global-map (kbd "C-Z") 'redo))


;; Auto Complete
;;
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)          ;; 曖昧マッチ


;;php-mode
(require 'php-mode)

;;括弧を表示する
(require 'smartparens-config)
(smartparens-global-mode t)


;;クリップボードの共有
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)