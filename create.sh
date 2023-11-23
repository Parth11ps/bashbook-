#!/bin/bash

if [ $# -ne 1 ]; then
  echo "nok: no identifier provided"
  exit 1
fi

id=$1

if [ -d "$id" ]; then
  echo "nok: user already exists"
  exit 1
fi

mkdir "$id" || { echo "nok: failed to create user directory"; exit 1; }
touch "$id/wall.txt" "$id/friends.txt" || { echo "nok: failed to initialize user files"; rmdir "$id"; exit 1; }

echo "ok: user created!"
