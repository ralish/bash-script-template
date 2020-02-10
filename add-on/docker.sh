#!/usr/bin/env bash

function dkr_multiline {
  docker cmd on multi lines

  docker run -dit ... mysql $(cat <<EOF
  SELECT foo, bar FROM db
  WHERE foo='baz'
  EOF
  )
}
