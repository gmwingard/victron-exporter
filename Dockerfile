# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.17-alpine AS builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -ldflags="-s -w" -o /out/victron-exporter .

FROM alpine:3.16
COPY --from=builder /out/victron-exporter /usr/local/bin/victron-exporter
ENTRYPOINT ["/usr/local/bin/victron-exporter"]
