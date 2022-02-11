export CGO_ENABLED=0
BUILD_NUMBER=$(shell cat version.txt)

BINARY_NAME=tbtail

vendor:
	go mod vendor

build-deps:
	go build ../libtb-go
	go install ../libtb-go

build:
	mkdir -p bin
	GOARCH=amd64 GOOS=linux go build -o bin/$(BINARY_NAME)_${BUILD_NUMBER}_linux_amd64 -ldflags "-X main.BuildID=${BUILD_NUMBER}" .


install: 
	go install -ldflags "-X main.BuildID=${BUILD_NUMBER}" 

clean:
	rm -rf ./bin
	rm -f $(GOPATH)/bin/tbtail
	rm -f $(GOPATH)/bin/tbtail*

build-all: build-deps build

install-all: build-deps install

cross-build-old:
	export CGO_LDFLAGS="-Xlinker -rpath=/path/to/another_glibc/lib64"
	CGO_LDFLAGS="$(CGO_LDFLAGS) -Xlinker --dynamic-linker="/path/to/another_glibc/lib64/ld-linux-x86-64.so.2"
	build-all

.PHONY: build-package
build-package:
	$(bash ./build-pkg.sh -v "${BUILD_NUMBER}" -t deb)
	$(bash ./pkg-test/test.sh "${BUILD_NUMBER}")
	

package: clean install build-package

run:
	go run main.go