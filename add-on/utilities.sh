#!/usr/bin/env bash

function passgen_long {
  # requires openssl
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 48 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-50) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}