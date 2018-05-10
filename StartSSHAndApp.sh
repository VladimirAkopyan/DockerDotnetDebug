#!/bin/bash

# Start the first process
dotnet /app/DebugSample.dll </dev/null &>/dev/null &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ASP Server: $status"
  exit $status
fi

/usr/sbin/sshd -D
if [ $status -ne 0 ]; then
  echo "Failed to start Ssh Server: $status"
  exit $status
fi

# Naive check runs to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 5 seconds

while sleep 5; do
  ps aux |grep dotnet |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep sshd |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done

