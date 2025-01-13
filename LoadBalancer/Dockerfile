FROM golang:1.23.4

WORKDIR /app

COPY go.mod ./
COPY . .

RUN go build -o loadbalancer ./cmd/main.go

EXPOSE 8080

CMD ["./loadbalancer"]

