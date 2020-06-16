BINARY := pwned
VERSION := $(shell ./git_versioner.py)
SOURCE := main.go go.mod go.sum

.PHONY: dist clean all

build/$(BINARY)-darwin: $(SOURCE)
	mkdir -p build
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o build/$(BINARY)-darwin

build/$(BINARY)-linux: $(SOURCE)
	mkdir -p build
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o build/$(BINARY)-linux

build/$(BINARY)-linuxarmhf: $(SOURCE)
	mkdir -p build
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -ldflags "-X main.version=$(VERSION)" -o build/$(BINARY)-linuxarmhf

build/$(BINARY)-linuxarm64: $(SOURCE)
	mkdir -p build
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o build/$(BINARY)-linuxarm64

dist/$(BINARY).exe: $(SOURCE)
	mkdir -p dist
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o dist/$(BINARY).exe

build/shar.tar.gz: build/$(BINARY)-darwin build/$(BINARY)-linux build/$(BINARY)-linuxarmhf build/$(BINARY)-linuxarm64 shar/README-shar shar/install.sh
	tar cfz build/shar.tar.gz -C build $(BINARY)-darwin $(BINARY)-linux $(BINARY)-linuxarmhf $(BINARY)-linuxarm64 -C ../shar README-shar install.sh

dist/$(BINARY)-install.sh: build/shar.tar.gz shar/sh-header
	mkdir -p dist
	cat shar/sh-header build/shar.tar.gz > dist/$(BINARY)-install.sh
	chmod 755 dist/$(BINARY)-install.sh


all: dist/$(BINARY)-install.sh dist/$(BINARY).exe ## Make everything

clean: ## Clean everything
	rm -rf build || true
	rm -rf dist || true

help: ## Show this help
	@echo "These are the make commands for the pwned CLI.\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
