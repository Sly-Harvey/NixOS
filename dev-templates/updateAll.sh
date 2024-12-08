#!/usr/bin/env bash

scriptdir=$(realpath "$(dirname "$0")")

for template in "$scriptdir"/*/; do
  template=${template%*/}
  cd "$template"
  nix flake update
done
