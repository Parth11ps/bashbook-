#!/bin/bash

if [ $# -ne 2 ]; then
  echo "nok: incorrect number of parameters"
  exit 1
fi

id=$1
friend=$2

if [ ! -d "$id" ]; then
  echo "nok: user '$id' does not exist"
  exit 1
fi

if [ ! -d "$friend" ]; then
  echo "nok: user '$friend' does not exist"
  exit 1
fi

if grep -q "^$friend$" "$id/friends.txt"; then
  echo "nok: user '$friend' is already a friend of '$id'"
  exit 1
fi

echo "$friend" >> "$id/friends.txt"
echo "ok: friend added!"
