FROM dart:stable AS build

WORKDIR /app
COPY . /app
RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server

FROM dart:stable
LABEL io.modelcontextprotocol.server.name="io.github.Nilesh9783/flutter_structure_mcp"
LABEL org.opencontainers.image.source="https://github.com/Nilesh9783/flutter_structure_mcp"
LABEL org.opencontainers.image.description="Audit architecture, security, memory, and code quality in Flutter, Laravel, Node, Python, & Vue."

WORKDIR /app
COPY --from=build /app/bin/server /app/bin/server
ENTRYPOINT ["/app/bin/server"]