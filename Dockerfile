# base image for building the Go application
FROM golang:1.22.5 AS builder

# set the working directory
WORKDIR /app

# copy go.mod and go.sum files to the working directory
# and download dependencies
COPY go.mod .
RUN go mod download

# copy the source code to the working directory
COPY . .

# build the Go application
RUN go build -o main .

# use a minimal base image for the final image
FROM gcr.io/distroless/base

# copy the built binary and static files from the builder stage
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080
ENTRYPOINT ["./main"]