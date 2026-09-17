# BashBook

A small social-networking simulation built with Bash and plain-text files. BashBook explores user profiles, directional friend lists, wall posts, and local inter-process communication using named pipes.

> **Status:** Learning prototype. The helper scripts can be invoked directly; the experimental client/server path requires fixes before end-to-end use.

## Features implemented in the helper scripts

- Create a user directory with an empty wall and friend list.
- Add an existing user to another user's friend list, with duplicate checks.
- Post messages to a recipient's wall when the sender is on that recipient's friend list.
- Display wall contents between `start_of_file` and `end_of_file` markers.
- Return simple `ok:` and `nok:` status messages.

Friendships are directional: adding Alice to Bob's friend list allows Alice to post on Bob's wall. It does not automatically add Bob to Alice's list.

## Quick start: direct-script demo

Use Bash on Linux, macOS, or a suitable Unix-like environment. Run these commands from a fresh clone; the scripts store data relative to the current directory.

```bash
git clone https://github.com/Parth11ps/bashbook-.git
cd bashbook-

bash create.sh alice
bash create.sh bob
bash add_friend.sh bob alice
bash post_messages.sh alice bob "Hello from Alice!"
bash display_wall.sh bob
```

Expected final output:

```text
start_of_file
alice: Hello from Alice!
end_of_file
```

This example is derived from the source and has not been validated in an automated test suite. Repeating user creation in the same directory returns an already-exists error.

## Script reference

| File | Purpose | Arguments |
| --- | --- | --- |
| `create.sh` | Create a profile | `<user_id>` |
| `add_friend.sh` | Add a friend to a user's list | `<user_id> <friend_id>` |
| `post_messages.sh` | Append a post to a recipient's wall | `<sender> <receiver> <message...>` |
| `display_wall.sh` | Print a user's wall | `<user_id>` |
| `client.sh` | Experimental interactive FIFO client | `<user_id>` |
| `server.sh` | Experimental request dispatcher | None |

Each profile uses `<user_id>/friends.txt` and `<user_id>/wall.txt`. Bash and standard utilities such as `grep`, `cat`, `mkdir`, and `touch` are sufficient for the direct demo. The experimental client/server scripts also use `mkfifo`, `awk`, and `tput`.

## Client/server design

The intended design sends client requests through `server.pipe`, dispatches each request to a helper script, and returns output through a user-specific response pipe.

The current implementation has known integration issues:

- The server writes `$response` without capturing the helper script's output into it.
- Add-friend and post-message request parsing does not pass the expected arguments.
- The tracked `server.pipe` is a regular file, not a FIFO; Git does not preserve named pipes.
- The server invokes helpers with `./script.sh`, but their committed file modes are not executable.
- Concurrent requests and shared file writes have no locking.

Use the direct-script demo while these pieces are unfinished.

## Scope and limitations

This is a local shell-scripting exercise, with no authentication, network service, database, or web interface. User IDs become filesystem paths and are not validated; use simple alphanumeric test IDs in a disposable project directory. Friend checks interpret IDs as regular expressions, so special characters should be avoided.

## Development priorities

- Repair request parsing and response routing.
- Create and clean up runtime FIFOs safely.
- Validate identifiers and use literal friend matching.
- Add tests for missing users, duplicate friends, and posting permissions.
- Add locking for concurrent writes.

## Skills demonstrated

Shell scripting, argument handling, text-file persistence, permission checks, process control, and an experimental FIFO-based communication design.
