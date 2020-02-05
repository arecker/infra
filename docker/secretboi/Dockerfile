FROM golang:alpine as builder
MAINTAINER Alex Recker <alex@reckerfamily.com>
RUN mkdir /build 
ADD secretboi.go /build/
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o secretboi .
FROM scratch
COPY --from=builder /build/secretboi /app/
WORKDIR /app
CMD ["./secretboi"]


