#!/usr/bin/env bash

function who {

cat <<EOF > bashlava_help.md

## I'm Pascal Andy

- https://twitter.com/askpascalandy
- https://github.com/firepress-org/bashlava

EOF
input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}