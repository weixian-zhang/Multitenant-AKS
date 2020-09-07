FROM golang:1.12-alpine AS build_base


RUN apk add --no-cache git

# Set the Current Working Directory inside the container
WORKDIR /app

# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

# Build the Go app
RUN go build -o ./out .

# Start fresh from a smaller image
FROM alpine:3.9

COPY --from=build_base /app/out /app/main

# Run the binary program produced by `go install`
CMD ["/app/main"]