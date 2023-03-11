FROM golang:1.18
WORKDIR /app
COPY go.mod go.mod
COPY go.sum go.sum
COPY src/ src/
RUN go build -o workflow-api ./src/main.go
ENTRYPOINT /app/workflow-api
