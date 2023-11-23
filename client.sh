#!/bin/bash

# Define colors
BLUE_TEXT=$(tput setaf 4)
RESET=$(tput sgr0)

# Display BashBook banner
echo "${BLUE_TEXT}____               ._      ____               _"
echo "\\__   \\__    __|  |_   \\__   \\ __   __ |  | _"
echo " |    |  /\\_  \\  /  _/  |  \\   |    |  _//  _ \\ /  _ \\|  |/ /"
echo " |    |   \\ / _ \\\\_ \\|   Y  \\  |    |   (  <> |  <> )    <"
echo " |__  /(__  /__  >_|  /  |__  /\\_/ \\_/|_| \\"
echo "${RESET}"

echo "Welcome to Bashbook!"
echo "..."

if [ $# -ne 1 ]; then
  echo "Usage: $0 <user_id>"
  exit 1
fi

id=$1
request_pipe="server.pipe"
response_pipe="$id.pipe"

trap "rm -f $response_pipe; exit 0" INT  # Delete the named pipe on Ctrl+C

mkfifo "$response_pipe"  # Create a named pipe for receiving responses

while true; do
  read -p "Enter request (e.g., req args): " user_request

  if [ -z "$user_request" ]; then
    echo "Invalid request. Try again."
    continue
  fi

  echo "$user_request $id" > "$request_pipe"  # Send request to the server

  # Wait for and read the server's response
  server_response=$(cat "$response_pipe")

  # Process and display the server's response in a user-friendly way
  case $server_response in
    ok:*) echo "SUCCESS: ${server_response#ok:}" ;;
    nok:*) echo "ERROR: ${server_response#nok:}" ;;
    *) echo "$server_response" ;;
  esac
done
