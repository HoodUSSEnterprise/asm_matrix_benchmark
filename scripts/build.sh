#!/usr/bin/env bash

echo "Bulid this program is $(pwd)"

mkdir -p build
cd build || exit 1
cmake -DCMAKE_BUILD_TYPE=Debug .. || exit 1
make || exit 1
cd ..

echo "Bulid Complete"

