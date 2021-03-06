#!/bin/bash

###
# Copyright 2016 resin.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###

set -u
set -e

ASAR="./node_modules/.bin/asar"

./scripts/build/check-dependency.sh "$ASAR"

function usage() {
  echo "Usage: $0"
  echo ""
  echo "Options"
  echo ""
  echo "    -d <directory>"
  echo "    -o <output>"
  exit 1
}

ARGV_DIRECTORY=""
ARGV_OUTPUT=""

while getopts ":d:o:" option; do
  case $option in
    d) ARGV_DIRECTORY=$OPTARG ;;
    o) ARGV_OUTPUT=$OPTARG ;;
    *) usage ;;
  esac
done

if [ -z "$ARGV_DIRECTORY" ] || [ -z "$ARGV_OUTPUT" ]; then
  usage
fi

# Omit `*.dll` and `*.node` files from the
# asar package, otherwise `process.dlopen` and
# `module.require` can't load them correctly.
"$ASAR" pack "$ARGV_DIRECTORY" "$ARGV_OUTPUT" \
  --unpack "{*.dll,*.node}"
