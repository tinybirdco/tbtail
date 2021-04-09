export CGO_ENABLED=0

BINARY_NAME=tbtail

vendor:
	go mod vendor

build-deps:
	go build ../libtb-go
	go install ../libtb-go

build:
	mkdir -p bin
	go build -o bin/$(BINARY_NAME) .

install: 
	go install

clean:
	rm -rf ./bin

build-all: build-deps build

install-all: build-deps install

cross-build-old:
	export CGO_LDFLAGS="-Xlinker -rpath=/path/to/another_glibc/lib64"
	CGO_LDFLAGS="$CGO_LDFLAGS -Xlinker --dynamic-linker="/path/to/another_glibc/lib64/ld-linux-x86-64.so.2"
	build-all

run:
	go run main.go