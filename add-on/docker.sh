#!/usr/bin/env bash

function lint {
  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    redcoolbeans/dockerlint
}

function lint_hado {
# tk wip
  docker run --rm hadolint/hadolint:v1.16.3-4-gc7f877d hadolint --version && echo;

  docker run --rm -i hadolint/hadolint:v1.16.3-4-gc7f877d hadolint \
    --ignore DL3000 \
    - < Dockerfile && \

  echo && \
  docker run -v `pwd`/Dockerfile:/Dockerfile replicated/dockerfilelint /Dockerfile
}
