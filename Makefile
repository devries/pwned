BINARY = pwned

darwin: build/$(BINARY)-darwin

build/$(BINARY)-darwin:
	mkdir -p build
	GOOS=darwin GOARCH=amd64 go build -o build/$(BINARY)-darwin

linux: build/$(BINARY)-linux

build/$(BINARY)-linux:
	mkdir -p build
	GOOS=linux GOARCH=amd64 go build -o build/$(BINARY)-linux

build/shar.tar.gz: build/$(BINARY)-darwin build/$(BINARY)-linux shar/README-shar shar/install.sh
	tar cfz build/shar.tar.gz -C build $(BINARY)-darwin $(BINARY)-linux -C ../shar README-shar install.sh

$(BINARY)-install.sh: build/shar.tar.gz shar/sh-header
	cat shar/sh-header build/shar.tar.gz > $(BINARY)-install.sh
	chmod 755 $(BINARY)-install.sh

dist: $(BINARY)-install.sh

clean:
	rm -rf build || true
	rm -f $(BINARY)-install.sh || true
