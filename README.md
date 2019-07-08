
This module adds the Theia Structure from Motion library to tp_pipeline. To use this you will need to build and install the Theia libraries.

## Building Theia Fedora

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
Run the following script in the directory where you want to perform the build.
```
mkdir theia
cd theia
git clone https://github.com/wrld3d/tp_pipeline_theia.git
./tp_pipeline_theia/scripts/build_fedora.sh

```


## Building Theia iOS
Run the following script in the directory where you want to perform the build.
```
brew install wget coreutils

mkdir theia
cd theia
git clone https://github.com/wrld3d/tp_pipeline_theia.git
./tp_pipeline_theia/scripts/build_ios.sh

```

