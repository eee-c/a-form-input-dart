#!/bin/bash

# Static type analysis
results=$(dartanalyzer lib/a_form_input.dart 2>&1)
echo "$results"
if [[ "$results" != *"No issues found"* ]]
then
    exit 1
fi
echo "Looks good!"
echo

pub serve &
pub_pid=$!

# Wait for server to build elements and spin up...
sleep 15

# Run a set of Dart Unit tests
results=$(content_shell --dump-render-tree http://localhost:8080)
echo -e "$results"

kill $pub_pid


# check to see if DumpRenderTree tests
# fails, since it always returns 0
if [[ "$results" == *"Some tests failed"* ]]
then
    exit 1
fi

if [[ "$results" == *"Exception: "* ]]
then
    exit 1
fi
