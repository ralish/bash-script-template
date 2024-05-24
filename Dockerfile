ARG base_image_version=bookworm-slim

FROM debian:$base_image_version AS build
WORKDIR /script
COPY *.sh .
RUN ./build.sh

FROM debian:$base_image_version
RUN apt-get update && apt-get install --yes jq inotify-tools && apt-get clean
ENTRYPOINT ["/bin/bash", "/usr/local/bin/openaudible-organiser", "--no-colour"]
COPY --from=build --chmod=755 /script/template.sh /usr/local/bin/openaudible-organiser
