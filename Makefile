.PHONY: test clean all

all: bin/agent bin/server bin/health

bin/agent: $(shell find . -name '*.go') proto/service.pb.go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/agent cmd/agent/*.go

bin/server: $(shell find . -name '*.go') proto/service.pb.go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/server cmd/server/*.go

bin/health: $(shell find . -name '*.go') proto/service.pb.go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/health cmd/health/*.go

proto/service.pb.go: proto/service.proto
	go get -u -v github.com/golang/protobuf/protoc-gen-go
	protoc -I proto/ proto/service.proto --go_out=plugins=grpc:proto

test: $(shell find . -name '*.go')
	go test test/unit/*_test.go
	go test test/functional/*_test.go

clean:
	rm -rf bin/