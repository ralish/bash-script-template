#!/usr/bin/env bash

function title-core-fct {
cat <<EOF > bashlava_help.md
# Core functions are:
EOF
input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}

# password generator. See also "passgen_long" These char are not part of the password to minimize human error: i,I,L,l,o,O,0
function passgen { docker run ctr.run/github.com/firepress-org/alpine:master sh -c "/usr/local/bin/random3.sh";
}

function passgen_long {
  # requires openssl
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 48 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-50) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}