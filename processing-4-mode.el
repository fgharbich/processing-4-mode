;;; processing-4-mode.el --- A minimalist processing-4 mode -*- lexical-binding: t -*-

;; Copyright © 2019 Love Lagerkvist
;; Copyright © 2025 Florentin G. Harbich

;; Author: Love Lagerkvist, Florentin G. Harbich
;; Package: processing-4-mode
;; URL: https://github.com/fgharbich/processing-4-mode
;; Package-Requires: ((emacs "30"))
;; Created: 2019-11-16
;; Version: 2025-09-07
;; Keywords: extensions processing

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package is a minimalist Processing 4 mode that also contains a
;; wrapper for the `processing' command line tool.
;;

;;; Code:
(require 'compile)
(require 'subr-x)

;;; Customization
(defgroup processing-4 nil
  "Emacs processing-4-mode functions and settings."
  :group 'tools
  :prefix "processing-4-")

(defcustom processing-4-compile-cmd 'run
  "Set the command to run with `processing-4-mode-keymap-prefix+c'.
'run (default), 'build, 'present or 'export."
  :group 'processing-4
  :type 'symbol)

(defcustom processing-4-force nil
  "Set the processing `--force' flag.
nil (default) or t.
\nFrom the usage message:
The sketch will not build if the output folder
already exists, because the contents will be replaced.
This option erases the folder first. Use with extreme caution!"
  :group 'processing-4
  :type 'boolean
  :options '(t nil))

(defcustom processing-4-no-java nil
  "Set the processing `--no-java' flag.
nil (default) or t.
\nFrom the usage message:
Do not embed Java."
  :group 'processing-4
  :type 'boolean)

(defcustom processing-4-variant nil
  "Set the processing `--export' flag.
nil (default), 'windows-amd64, 'macosx-x86_64, 'macosx-aarch64,
'linux-amd64, 'linux-arm  or 'linux-aarch64.
\nFrom the usage message:
Specify the platform and architecture (Export only)."
  :group 'processing-4
  :type 'symbol)

(defcustom processing-4-args ""
  "Set a string of args to pass to `processing', default none.
For reference on how to use args:
https://github.com/processing/processing/wiki/Command-Line#adding-command-line-arguments"
  :group 'processing-4
  :type 'string
  :safe t)


;;; Internal functions
(define-compilation-mode processing-4-compilation-mode "processing-4-compilation"
  "processing-4-mode specific 'compilation-mode' derivative."
  (setq-local compilation-scroll-output t)
  (require 'ansi-color))

(defun processing-4--flags ()
  "Add flags to `cmd', if set."
  (string-join (list (when processing-4-no-java "--no-java")
                     (when processing-4-force "--force"))
               " "))

(defun processing-4--variant-arg (cmd)
  "Add `--variant' if `processing-4-variant' is set and `CMD' is `--export'.
Otherwise, return nil"
  (if (and processing-4-variant (string-equal cmd "--export"))
      (string-join (list (concat "--variant=" (symbol-name processing-4-variant))
                         (concat "--output=" default-directory (symbol-name processing-4-variant)))
                   " ")
    nil))

(defun processing-4--build-cmd (cmd)
  "Build the cmd, where `CMD' is one of `run', `build', `present' or `export'."
  (string-join (list "processing cli"
                     (processing-4--flags)
                     (concat "--sketch=" (shell-quote-argument default-directory))
                     (processing-4--variant-arg cmd)
                     cmd
                     processing-4-args)
               " "))

(defun processing-4--compile (cmd)
  "Run a processing-4 CMD in cli-compilation-mode."
  (save-some-buffers (not compilation-ask-about-save)
                     (lambda () default-directory))
  (compilation-start (processing-4--build-cmd cmd) 'processing-4-compilation-mode))


;;; User commands
(defun processing-4-run ()
  "Preprocess, compile, and run a sketch."
  (interactive)
  (processing-4--compile "--run"))

(defun processing-4-build ()
  "Preprocess and compile a sketch into .class files."
  (interactive)
  (processing-4--compile "--build"))

(defun processing-4-present ()
  "Preprocess, compile, and run a sketch in presentation mode."
  (interactive)
  (processing-4--compile "--present"))

(defun processing-4-export ()
  "Export a sketch."
  (interactive)
  (processing-4--compile "--export"))

(defun processing-4-compile-cmd ()
  "Run `processing' with `processing-4-compile-cmd' (default --run)."
  (interactive)
  (processing-4--compile (concat "--" (symbol-name processing-4-compile-cmd))))


;;; Major mode
(defvar processing-4-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c\C-r"  #'processing-4-run)
    (define-key map "\C-c\C-c"  #'processing-4-compile-cmd)
    (define-key map "\C-c\C-b"  #'processing-4-build)
    (define-key map "\C-c\C-p"  #'processing-4-present)
    (define-key map "\C-c\C-e"  #'processing-4-export)
    map)
  "Keymap for `processing-4-mode'.")


;;;###autoload
(define-derived-mode processing-4-mode
  java-mode "Processing 4"
  "Major mode for Processing 4. Provides convenience functions to use the `processing' cli.
\n\\{processing-4-mode-map}")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-4-mode))

(provide 'processing-4-mode)
;;; processing-4-mode.el ends here
