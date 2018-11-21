BINARY := pwned
VERSION := $(shell ./git_versioner.py)

darwin: build/$(BINARY)-darwin

build/$(BINARY)-darwin:
	mkdir -p build
	GOOS=darwin GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o build/$(BINARY)-darwin

linux: build/$(BINARY)-linux

build/$(BINARY)-linux:
	mkdir -p build
	GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o build/$(BINARY)-linux

build/shar.tar.gz: build/$(BINARY)-darwin build/$(BINARY)-linux shar/README-shar shar/install.sh
	tar cfz build/shar.tar.gz -C build $(BINARY)-darwin $(BINARY)-linux -C ../shar README-shar install.sh

dist/$(BINARY)-install.sh: build/shar.tar.gz shar/sh-header
	mkdir -p dist
	cat shar/sh-header build/shar.tar.gz > dist/$(BINARY)-install.sh
	chmod 755 dist/$(BINARY)-install.sh

windows: dist/$(BINARY).exe

dist/$(BINARY).exe:
	mkdir -p dist
	GOOS=windows GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o dist/$(BINARY).exe

shell: dist/$(BINARY)-install.sh 

all: shell windows
	echo $(VERSION)

clean:
	rm -rf build || true
	rm -rf dist || true
