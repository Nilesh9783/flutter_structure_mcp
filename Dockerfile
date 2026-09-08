FROM dart:stable AS build

WORKDIR /app
COPY . /app
RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server

FROM dart:stable
WORKDIR /app
COPY --from=build /app/bin/server /app/bin/server
ENTRYPOINT ["/app/bin/server"]