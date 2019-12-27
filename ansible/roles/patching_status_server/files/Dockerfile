FROM golang:1.8

WORKDIR /go/src/patching_status
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["patching_status"]