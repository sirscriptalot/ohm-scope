.PHONY: test

install: .gems
	gs dep install

test:
	gs cutest -r ./test/all.rb

.gems:
	mkdir -p .gs
