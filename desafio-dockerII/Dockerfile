# syntax=docker/dockerfile:1
FROM golang:1.21-alpine as build
WORKDIR /src
COPY main.go go.* /src/
RUN go build -o /bin/app ./main.go

FROM scratch
COPY --from=build /bin/app /bin/app
CMD ["/bin/app"]