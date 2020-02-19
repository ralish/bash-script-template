#!/usr/bin/env bash

function example_array {
  arr=( "hello" "world" "three" )
  
  for i in "${arr[@]}"; do
    echo ${i}
  done
}
function banner {
  figlet_message="Banner Test"
  App_figlet
}
