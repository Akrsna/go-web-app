FROM golang:1.22.5 as base
WORKDIR /app
#dependencies download
COPY go.mod . 
RUN go mod download
COPY . .
RUN go build -o main .
# binary main will be created in docker container

# final stage - distroless image
FROM gcr.io/distroless/base
# Copying the binary from stage 1
COPY --from=base /app/main .
# Copying the static files for the web page
COPY --from=base /app/static ./static
EXPOSE 8080
CMD [ "./main" ]

