#!/bin/bash 

set -ex

# Build TheiaSfM
mkdir -p usr/theia

git clone https://github.com/tompaynter03/TheiaSfM.git
cd TheiaSfM/
mkdir build_fedora
cd build_fedora/

unset INC_DIRS
export INC_DIRS=${INC_DIRS}"/usr/include/eigen3/\;"
export INC_DIRS=${INC_DIRS}"/usr/include/suitesparse/\;"

cmake ../src/theia \
      -DCMAKE_INSTALL_PREFIX:PATH="`realpath ../../usr`/theia/" \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DBUILD_LIB_theia_math=ON \
      -DBUILD_LIB_theia_sfm=ON \
      -DBUILD_LIB_theia_util=ON \
      -DBUILD_LIB_theia_solvers=ON \
      -DINCLUDE_DIRECTORIES=${INC_DIRS}

make -j`nproc` install VERBOSE=1
