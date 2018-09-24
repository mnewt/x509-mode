#!/usr/bin/env bash

DRIVE=/g

if [ -z "$1" ]; then
  NAME="${DRIVE}/$(basename ${PWD}).git.bundle"
else
  NAME="$"
fi

git bundle create "$NAME" master && echo "Created $NAME"
