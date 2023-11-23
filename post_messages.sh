#!/bin/bash

if [ $# -lt 3 ]; then
  echo "nok: incorrect number of parameters"
  exit 1
fi

sender=$1
receiver=$2
message="${*:3}"

if [ ! -d "$sender" ]; then
  echo "nok: user '$sender' does not exist"
  exit 1
fi

if [ ! -d "$receiver" ]; then
  echo "nok: user '$receiver' does not exist"
  exit 1
fi

if ! grep -q "^$sender$" "$receiver/friends.txt"; then
  echo "nok: user '$sender' is not a friend of '$receiver'"
  exit 1
fi

echo "$sender: $message" >> "$receiver/wall.txt"
echo "ok: message posted!"
