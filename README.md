
This module adds the Theia Structure from Motion library to tp_pipeline. To use this you will need to build and install the Theia libraries.

## Building Theia Library

### Dependencies
```
dnf update -y
dnf install -y eigen3-devel \
               ceres-solver-devel \
               OpenImageIO-devel \
               gflags-devel \
               blas-devel \
               lapack-devel \
               suitesparse-devel \
               libjpeg-turbo-devel \
               hdf5-devel \
               gtest-devel \
               freeglut-devel \
               OpenEXR-devel \
               rapidjson-devel \
               cmake
```

These currently don't work on my Xeon E5v2 or on Fedora 27:
```
dnf install -y rocksdb rocksdb-devel
```

### Build RocksDB
The RocksDB library in the repo fails to run on my older Xeon E5 v2 CPU because of non-portable CPU extensions. 
https://bugzilla.redhat.com/show_bug.cgi?id=1663175

```
mkdir rocksdb
cd rocksdb/
mkdir usr/
git clone https://github.com/facebook/rocksdb.git
cd rocksdb/
make -j`nproc` shared_lib
export INSTALL_PATH=`realpath ../usr/`
make -j`nproc` install

cd ../..

```

### Build
Following instructions on http://theia-sfm.org/building.html

#### Fedora 29 Xeon E5v2 And Fedora 27
These are workarounds for older Xeon CPUs or older versions of Fedora.
```
mkdir theia
cd theia
mkdir usr

git clone https://github.com/sweeneychris/TheiaSfM.git
cd TheiaSfM/

mkdir theia-build
cd theia-build

#Seems to be an error with the FindGflags.cmake script packaged in TheiaSfM.
cp /usr/lib64/cmake/Ceres/FindGflags.cmake ../cmake/FindGflags.cmake

#RocksDB issue on Fedora 29 Xeon E5 v2
cmake -DCMAKE_INSTALL_PREFIX:PATH=`realpath ../../usr` \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DROCKSDB_INCLUDE_DIR:PATH=`realpath ../../../rocksdb/usr/include` \
      -DROCKSDB_STATIC_LIBRARIES=`realpath ../../../rocksdb/usr/lib/librocksdb.so` \
      ..

make -j`nproc` VERBOSE=1
make install

cd ../../..

```

## Building Theia iOS
Run the following script in the directory where you want to perform the build.
```
mkdir theia
cd theia
git clone https://github.com/tdp-libs/tp_pipeline_theia.git
./tp_pipeline_theia/scripts/build_ios.sh

```

