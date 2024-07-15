help:
	@echo "make install -- install all modules"
	@echo "make help    -- [default] this help message"

install: modules/*
	./tool install $^

.PHONY: help install
