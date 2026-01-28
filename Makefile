.PHONY: build build-linux build-darwin clean

# Build variables
BINARY_NAME=sera
GIT_VERSION=$(shell git describe --tags --always --dirty)
# Reduce file size and remove build path info
FLAGS=-ldflags "-s -w" -trimpath

# Output directory
BUILD_DIR=.build

# Default target
build: clean build-linux build-darwin compress

build-linux:
	GOOS=linux GOARCH=386 go build $(FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)_$(GIT_VERSION)_linux_386 .
	GOOS=linux GOARCH=amd64 go build $(FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)_$(GIT_VERSION)_linux_amd64 .
	GOOS=linux GOARCH=arm64 go build $(FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)_$(GIT_VERSION)_linux_arm64 .

build-darwin:
	GOOS=darwin GOARCH=amd64 go build $(FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)_$(GIT_VERSION)_darwin_amd64 .
	GOOS=darwin GOARCH=arm64 go build $(FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)_$(GIT_VERSION)_darwin_arm64 .

clean:
	rm -rf $(BUILD_DIR)

compress:
	cd $(BUILD_DIR) && \
	for binary in $(BINARY_NAME)_*; do \
		tar -czf $$binary.tar.gz $$binary; \
	done && cd ..