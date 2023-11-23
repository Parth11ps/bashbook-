#!/bin/bash

if [ $# -ne 1 ]; then
  echo "nok: incorrect number of parameters"
  exit 1
fi

id=$1

if [ ! -d "$id" ]; then
  echo "nok: user '$id' does not exist"
  exit 1
fi

echo "start_of_file"
cat "$id/wall.txt"
echo "end_of_file"
