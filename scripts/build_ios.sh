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
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/gflags/ \
      -DIOS_PLATFORM=OS64 

make -j12 install

cd ../..

# Get and build glog
git clone https://github.com/google/glog.git
cd glog
mkdir build_ios
cd build_ios/

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/glog/ \
      -DGFLAGS_INCLUDE_DIR=../../usr/gflags/include/ \
      -DBUILD_TESTING=OFF \
      -DIOS_PLATFORM=OS64 

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
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/eigen/ \
      -DBUILD_TESTING=OFF \
      -DCMAKE_Fortran_COMPILER='' \
      -DIOS_PLATFORM=OS64 

make -j12 install

cd ../..

# Build Ceres-Solver
git clone https://github.com/ceres-solver/ceres-solver.git
cd ceres-solver
mkdir build_ios
cd build_ios/

sed -i .bac 's/-Qunused-arguments -mllvm -inline-threshold=600//g' ../CMakeLists.txt

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/ceres-solver/ \
      -DBUILD_TESTING=OFF \
      -DEXPORT_BUILD_DIR=ON \
      -DSUITESPARSE=OFF \
      -DEIGEN_INCLUDE_DIR=../../usr/eigen/include/eigen3/ \
      -DGFLAGS_INCLUDE_DIR=../../usr/gflags/include/ \
      -DGLOG_INCLUDE_DIR==../../usr/glog/include/ \
      -DIOS_PLATFORM=OS64 

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
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/openexr/ \
      -DOPENEXR_BUILD_PYTHON_LIBS=OFF \
      -DOPENEXR_BUILD_VIEWERS=OFF \
      -DOPENEXR_BUILD_TESTS=OFF \
      -DOPENEXR_BUILD_UTILS=OFF \
      -DOPENEXR_BUILD_ILMBASE=ON \
      -DOPENEXR_BUILD_STATIC=ON \
      -DOPENEXR_BUILD_SHARED=OFF \
      -DBUILD_ILMBASE_STATIC=ON \
      -DOPENEXR_TARGET_SUFFIX= \
      -DIOS_PLATFORM=OS64 

make -j12 install

cd ../..


# Build OpenImageIO
git clone https://github.com/OpenImageIO/oiio.git
cd oiio
mkdir build_ios
cd build_ios/

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/oiio/ \
      -DBUILD_TESTING=OFF \
      -DTIFF_LIBRARY=../../libtiff-ios/tiff-4.0.9/arm-apple-darwin64/lib \
      -DTIFF_INCLUDE_DIR=../../libtiff-ios/tiff-4.0.9/arm-apple-darwin64/include \
      -DPNG_LIBRARY=../../libtiff-ios//libpng-1.6.34/arm-apple-darwin64/lib \
      -DPNG_PNG_INCLUDE_DIR=../../libtiff-ios//libpng-1.6.34/arm-apple-darwin64/include \
      -DILMBASE_INCLUDE_DIR=../../usr/openexr/include/ \
      -DOPENEXR_INCLUDE_DIR=../../usr/openexr/include/ \
      -DIOS_PLATFORM=OS64 


# Build TheiaSfM

mkdir build_ios
cd build_ios/

sed -i .bac 's/SuiteSparse/EigenSparse/g' ../CMakeLists.txt

cmake .. \
      -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/ios.toolchain.cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../usr/theia/ \
      -DCERES_INCLUDE_DIR=../../usr/ceres-solver/include/ \
      -DGFLAGS_INCLUDE_DIR=../../usr/gflags/include/ \
      -DGLOG_INCLUDE_DIR==../../usr/glog/include/ \
      -DIOS_PLATFORM=OS64 

