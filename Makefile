.POSIX:
EMACS = emacs

NEEDED_PACKAGES = lsp-mode daml-mode package-lint

INIT_PACKAGES="(progn \
  (require 'package) \
  (push '(\"melpa\" . \"https://melpa.org/packages/\") package-archives) \
  (package-initialize) \
  (dolist (pkg '(${NEEDED_PACKAGES})) \
    (unless (package-installed-p pkg) \
      (unless (assoc pkg package-archive-contents) \
        (package-refresh-contents)) \
      (package-install pkg))) \
  )"

all: clean-elc compile package-lint

package-lint:
	${EMACS} -Q --eval ${INIT_PACKAGES} --eval '(setq package-lint-main-file "daml-lsp.el")' -batch -f package-lint-batch-and-exit daml-lsp.el

compile: clean-elc
	${EMACS} -Q --eval ${INIT_PACKAGES} -L . -batch -f batch-byte-compile daml-lsp.el

clean-elc:
	rm -f daml-lsp.elc

clean: clean-elc

.PHONY: all compile clean-elc package-lint
