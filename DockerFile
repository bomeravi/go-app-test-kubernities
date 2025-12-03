# Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod init helloapp || true
RUN go mod tidy
RUN go build -o app main.go

# Run stage
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .
EXPOSE 8090
ENV PORT=8090
CMD ["./app"]
