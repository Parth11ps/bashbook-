#!/bin/bash

request_pipe="server.pipe"
mkfifo "$request_pipe"  # Create a named pipe for receiving requests

while true; do
  # Read a request from the request pipe
  read -r user_request < "$request_pipe"

  # Process the request in a subshell to avoid blocking the loop
  (
    # Extract user ID from the request
    id=$(echo "$user_request" | awk '{print $NF}')
    
    # Process the request based on your existing server.sh logic
    case "$user_request" in
      create*) ./create.sh "$id" ;;
      add*) ./add_friend.sh "$id" "${user_request#add }" ;;
      post*) ./post_messages.sh "$id" "${user_request#post }" ;;
      display*) ./display_wall.sh "$id" ;;
      *) echo "nok: bad request" ;;
    esac

    # Send the response back to the client's named pipe
    echo "$response" > "$id.pipe"
  ) &
done
