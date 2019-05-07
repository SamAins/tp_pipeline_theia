#!/bin/bash 

set -e

# Get iOS CMake we will use this for building the rest of the libraries.
git clone https://github.com/leetal/ios-cmake.git


# Get and build gflags
git clone https://github.com/gflags/gflags.git
cd gflags/
mkdir build_ios
cd build_ios/

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/gflags/" \
      -DIOS_PLATFORM=OS 

make -j12 install

cd ../..


# Get and build glog
git clone https://github.com/google/glog.git
cd glog
mkdir build_ios
cd build_ios/

#Stack trace seems to be broken on iOS now?
sed -i .bac 's/STACKTRACE_H/STACKTRACE_H_OFF/g' ../src/utilities.cc

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/glog/" \
      -DGFLAGS_INCLUDE_DIR=../../usr/gflags/include/ \
      -DBUILD_TESTING=OFF \
      -DIOS_PLATFORM=OS 

make -j12 install

cd ../..


# Build Eigen
wget http://bitbucket.org/eigen/eigen/get/3.3.6.tar.bz2
tar xjf 3.3.6.tar.bz2
cd eigen-eigen-b70bf4fad467
mkdir build_ios
cd build_ios/

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/eigen/" \
      -DBUILD_TESTING=OFF \
      -DCMAKE_Fortran_COMPILER='' \
      -DIOS_PLATFORM=OS 

make -j12 install

cd `grealpath ../../usr/eigen/share/eigen3/cmake/`
ln -snf Eigen3Config.cmake        EigenConfig.cmake
ln -snf Eigen3ConfigVersion.cmake EigenConfigVersion.cmake
ln -snf Eigen3Targets.cmake       EigenTargets.cmake
ln -snf UseEigen3.cmake           UseEigen.cmake
cd -

cd ../..


# Build SuiteSparse
git clone https://github.com/mortennobel/SuiteSparse_Apple.git
cd SuiteSparse_Apple
sed -i .bac 's/libstdc++/libc++/g' SuiteSparse_config/SuiteSparse_config_ios.mk
./build_ios_lib.sh
#./install_ios_lib.sh

cd ..


# Build Ceres-Solver
git clone https://github.com/ceres-solver/ceres-solver.git
cd ceres-solver
mkdir build_ios
cd build_ios/

sed -i .bac 's/-Qunused-arguments -mllvm -inline-threshold=600//g' ../CMakeLists.txt

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DIOS_DEPLOYMENT_TARGET=9.0 \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/ceres-solver/" \
      -DBUILD_TESTING=OFF \
      -DEXPORT_BUILD_DIR=ON \
      -DSUITESPARSE=OFF \
      -DEigen3_DIR=`grealpath ../../usr/eigen/share/eigen3/cmake/` \
      -DEigen_DIR=`grealpath ../../usr/eigen/share/eigen3/cmake/` \
      -DGFLAGS_INCLUDE_DIR=`grealpath ../../usr/gflags/include/` \
      -DGLOG_INCLUDE_DIR==`grealpath ../../usr/glog/include/` \
      -DIOS_PLATFORM=OS

make -j12 install

cd ../..


# Build libtiff etc...
git clone https://github.com/ashtons/libtiff-ios.git
cd libtiff-ios
make

cd ..


# Build OpenEXR
git clone https://github.com/tompaynter03/openexr.git
cd openexr

mkdir build_native
cd build_native/

cmake .. \
      -DOPENEXR_BUILD_PYTHON_LIBS=OFF \
      -DOPENEXR_BUILD_VIEWERS=OFF \
      -DOPENEXR_BUILD_TESTS=OFF

cd ..

mkdir build_ios
cd build_ios/

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/openexr/" \
      -DOPENEXR_BUILD_PYTHON_LIBS=OFF \
      -DOPENEXR_BUILD_VIEWERS=OFF \
      -DOPENEXR_BUILD_TESTS=OFF \
      -DOPENEXR_BUILD_UTILS=OFF \
      -DOPENEXR_BUILD_ILMBASE=ON \
      -DOPENEXR_BUILD_STATIC=ON \
      -DOPENEXR_BUILD_SHARED=OFF \
      -DBUILD_ILMBASE_STATIC=ON \
      -DOPENEXR_TARGET_SUFFIX= \
      -DIOS_PLATFORM=OS 

make -j12 install

cd ../..


# Build Boost
git clone https://github.com/faithfracture/Apple-Boost-BuildScript.git
cd Apple-Boost-BuildScript
./boost.sh  -ios \
            --ios-sdk 12.2 \
            --min-ios-version 8.0 \
            --boost-version 1.69.0 \
            --boost-libs "exception filesystem regex thread"

cd ../..


# Build OpenImageIO
git clone https://github.com/OpenImageIO/oiio.git
cd oiio
mkdir build_ios
cd build_ios/
      
cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/oiio/" \
      -DBUILD_TESTING=OFF \
      -DTIFF_LIBRARY=`grealpath ../../libtiff-ios/dependencies/lib/libtiff.a` \
      -DTIFF_INCLUDE_DIR=`grealpath ../../libtiff-ios/tiff-4.0.9/arm-apple-darwin64/include` \
      -DPNG_LIBRARY=`grealpath ../../libtiff-ios/dependencies/lib/libpng.a` \
      -DPNG_PNG_INCLUDE_DIR=`grealpath ../../libtiff-ios//libpng-1.6.34/arm-apple-darwin64/include` \
      -DJPEG_LIBRARY=`grealpath ../../libtiff-ios/dependencies/lib/libjpeg.a` \
      -DJPEG_INCLUDE_DIR=`grealpath ../../libtiff-ios/jpeg-9a/arm-apple-darwin64/include` \
      -DILMBASE_INCLUDE_DIR=`grealpath ../../usr/openexr/include/` \
      -DOPENEXR_INCLUDE_DIR=`grealpath ../../usr/openexr/include/` \
      -DOPENEXR_LIBRARIES=`grealpath ../../usr/openexr/lib/libHalf-2_3_s.a`\;`grealpath ../../usr/openexr/lib/libIex-2_3_s.a`\;`grealpath ../../usr/openexr/lib/libIlmThread-2_3_s.a`\;`grealpath ../../usr/openexr/lib/libIlmImf-2_3_s.a` \
      -DILMBASE_LIBRARIES=`grealpath ../../usr/openexr/lib/libHalf-2_3_s.a`\;`grealpath ../../usr/openexr/lib/libIex-2_3_s.a`\;`grealpath ../../usr/openexr/lib/libIlmThread-2_3_s.a`\;`grealpath ../../usr/openexr/lib/libIlmImf-2_3_s.a` \
      -DBOOST_CUSTOM=ON \
      -DBoost_VERSION=106900 \
      -DBoost_INCLUDE_DIRS=`grealpath ../../Apple-Boost-BuildScript/build/boost/1.69.0/ios/release/prefix/include/` \
      -DBoost_LIBRARY_DIRS=`grealpath ../../Apple-Boost-BuildScript/build/boost/1.69.0/ios/release/prefix/lib/` \
      -DBoost_LIBRARIES=-lboost_filesystem\;-lboost_thread\;-lboost_exception\;-lboost_system\;-lboost_regex\;-lboost_atomic \
      -DUSE_QT=OFF \
      -DGIT_EXECUTABLE=/usr/bin/git \
      -DBUILD_MISSING_ROBINMAP=ON \
      -DBUILD_ROBINMAP_FORCE=OFF \
      -DROBINMAP_GIT_REPOSITORY="https://github.com/Tessil/robin-map.git" \
      -DROBINMAP_INSTALL_DIR=robin-map \
      -DUSE_PYTHON=OFF \
      -DSTOP_ON_WARNING=OFF \
      -DBUILD_DOCS=OFF \
      -DVERBOSE=ON \
      -DENABLE_ARC=0 \
      -DBUILDSTATIC=ON \
      -DUSE_STD_REGEX_EXITCODE:INTERNAL=0 \
      -DOIIO_BUILD_TESTS=OFF \
      -DIOS_PLATFORM=OS 

make -j12 install

cd ../..


# Build RocksDB
git clone https://github.com/facebook/rocksdb.git
cd rocksdb
mkdir build_ios
cd build_ios

sed -i .bac 's/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")/\#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")/g' ../CMakeLists.txt
sed -i .bac 's/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")/\#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")/g' ../CMakeLists.txt

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/rocksdb/" \
      -DWITH_TESTS=OFF \
      -DWITH_TOOLS=OFF \
      -DIOS_PLATFORM=OS 

make -j12 install

cd ../..


# Build TheiaSfM

cd TheiaSfM/libraries/optimo/
mkdir build_ios
cd build_ios

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../../../usr`/optimo/" \
      -DCMAKE_MODULE_PATH=`grealpath ../../../cmake/` \
      -DIOS_PLATFORM=OS

make -j12 install

cd ../../../..

cd TheiaSfM/
mkdir build_ios
cd build_ios/
      
cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DIOS_DEPLOYMENT_TARGET=11.0 \
      -DCMAKE_INSTALL_PREFIX:PATH="`grealpath ../../usr`/theia/" \
      -DCERES_INCLUDE_DIR=../../usr/ceres-solver/include/ \
      -DGFLAGS_INCLUDE_DIR=../../usr/gflags/include/ \
      -DGLOG_INCLUDE_DIR=../../usr/glog/include/ \
      -DGLOG_LIBRARY=../../usr/glog/lib/libglog.a \
      -DOPENEXR_INCLUDE_DIR=../../usr/openexr/include/ \
      -DOPENIMAGEIO_INCLUDE_DIR=../../usr/oiio/include/ \
      -DOPENIMAGEIO_LIBRARY=../../usr/oiio/lib/libOpenImageIO.a \
      -DROCKSDB_INCLUDE_DIR=../../usr/rocksdb/include/ \
      -DROCKSDB_LIBRARY=../../usr/rocksdb/lib/librocksdb.a \
      -DROCKSDB_STATIC_LIBRARIES=../../usr/rocksdb/lib/librocksdb.a \
      -DJPEG_LIBRARY=`grealpath ../../libtiff-ios/dependencies/lib/libjpeg.a` \
      -DJPEG_INCLUDE_DIR=`grealpath ../../libtiff-ios/jpeg-9a/arm-apple-darwin64/include` \
      -DOPTIMO_INCLUDE_DIR=../../usr/optimo/ \
      -DCMAKE_CXX_STANDARD=17 \
      -DBUILD_TESTING=OFF \
      -DSUITESPARSE_INCLUDE_DIR_HINTS=/Users/tom/theia/TheiaSfM/build_ios/../../usr/suitesparse/include/ \
      -DSUITESPARSE_LIBRARY_DIR_HINTS=/Users/tom/theia/TheiaSfM/build_ios/../../usr/suitesparse/lib/ \
      -DCMAKE_CXX_FLAGS="-I`grealpath ../../usr/openexr/include/`" \
      -DIOS_PLATFORM=OS64

make -j12 install
