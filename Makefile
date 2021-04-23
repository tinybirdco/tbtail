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
	go build -o bin/$(BINARY_NAME) -ldflags "-X main.BuildID=${BUILD_NUMBER}" .

install: 
	go install -ldflags "-X main.BuildID=${BUILD_NUMBER}" 

clean:
	rm -rf ./bin
	rm -f $(GOPATH)/bin/tbtail
	rm -f $(GOPATH)/bin/tbtail*

build-all: build-deps build

install-all: build-deps install

package: 
	$(shell ./build-pkg.sh -v "${BUILD_NUMBER}" -t deb)
	$(shell pkg-test/test.sh "${BUILD_NUMBER}")

cross-build-old:
	export CGO_LDFLAGS="-Xlinker -rpath=/path/to/another_glibc/lib64"
	CGO_LDFLAGS="$(CGO_LDFLAGS) -Xlinker --dynamic-linker="/path/to/another_glibc/lib64/ld-linux-x86-64.so.2"
	build-all

run:
	go run main.go