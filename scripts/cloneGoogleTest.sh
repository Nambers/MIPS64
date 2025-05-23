#!/bin/sh

git clone https://github.com/google/googletest.git
cd googletest
mkdir build
cd build
cmake ..
make -j$(( $(nproc) - 1)) 
