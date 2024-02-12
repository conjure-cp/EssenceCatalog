#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)

pushd csplib/Problems > /dev/null                       # go through all problems in csplib
for prob in *;
do
    pushd "${prob}" > /dev/null
    if [ -d models ]; then                              # if it has a models directory
        pushd models > /dev/null
        for essence in *.essence; do                    # go through all essence files under the models directory
            essence_base="${essence%.*}"
            TARGET_DIR="${ROOT_DIR}/problems/csplib-${prob}-${essence_base}"
            mkdir -p "${TARGET_DIR}"
            cp "${essence}" "${TARGET_DIR}"             # and copy the essence file to problems/csplib-probNUMBER
        done
        popd > /dev/null
    fi
    popd > /dev/null
done
popd > /dev/null

