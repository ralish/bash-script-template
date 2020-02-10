#!/usr/bin/env bash

function ex_array {
  arr=( "hello" "world" "three" )
  
  for i in "${arr[@]}"; do
    echo ${i}
  done
}
function banner {
  figlet_message="Hey figlet"
  App_figlet
}
