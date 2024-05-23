FROM debian:latest AS build
WORKDIR /script
COPY *.sh .
RUN ./build.sh

FROM debian:latest
COPY --from=build --chmod=755 /script/template.sh /usr/local/bin/openaudible-organiser
RUN apt-get update && apt-get install --yes jq inotify-tools && apt-get clean
ENTRYPOINT ["/bin/bash", "/usr/local/bin/openaudible-organiser", "--no-colour"]
