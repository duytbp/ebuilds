#! /bin/bash

jj diff --name-only | grep '\.ebuild$' | xargs -I _file ebuild _file manifest
