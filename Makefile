help:
	@echo "# install all modules"
	@echo "make install"
	@echo
	@echo "# install the bash module"
	@echo "make install MODULE=modules/bash"
	@echo
	@echo "# install the ssh and tmux modules (note the quotes!)"
	@echo "make install MODULES='modules/ssh modules/tmux'"
	@echo
	@echo "# [default] this help message"
	@echo "make help"

MODULES=$(glob modules/*) $(MODULE)

install: $(MODULES)
	./tool install $^

.PHONY: help install
