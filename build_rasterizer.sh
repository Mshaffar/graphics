#!/usr/bin/env bash

set -e
set -x

apt-get update

apt-get -y install libgles2-mesa-dev
apt-get -y install libc-ares-dev
cp -rf /usr/include/GLES3 /dt7/usr/include/.
apt-get -y remove libgles2-mesa-dev libc-ares-dev


apt-get -y install unar
rm -rf libegl1-mesa* libgles2-mesa* libglapi-mesa*

wget http://old-releases.ubuntu.com/ubuntu/pool/main/m/mesa/libegl1-mesa_7.10.2-0ubuntu2.1_amd64.deb
unar libegl1-mesa_7.10.2-0ubuntu2.1_amd64.deb
mkdir libegl1-mesa
tar --lzma -C libegl1-mesa -xvpf libegl1-mesa_7.10.2-0ubuntu2.1_amd64/data.tar.lzma
mkdir -p /usr/lib/x86_64-linux-gnu/mesa-egl
cp libegl1-mesa/usr/lib/libEGL.so.1.0 /usr/lib/x86_64-linux-gnu/mesa-egl/libEGL.so.1.0.0

wget http://ppa.launchpad.net/xorg-edgers/ppa/ubuntu/pool/main/m/mesa/libgles2-mesa_18.0.5-0ubuntu0~16.04.1~ppa1_amd64.deb
unar libgles2-mesa_18.0.5-0ubuntu0~16.04.1~ppa1_amd64.deb
mkdir libgles2-mesa
tar --lzma -C libgles2-mesa -xvpf libgles2-mesa_18.0.5-0ubuntu0~16.04.1~ppa1_amd64/data.tar.xz
cp libgles2-mesa/usr/lib/x86_64-linux-gnu/mesa-egl/libGLESv2.so.2 /usr/lib/x86_64-linux-gnu/mesa-egl/.
ln -s /usr/lib/x86_64-linux-gnu/mesa-egl/libGLESv2.so.2 /usr/lib/x86_64-linux-gnu/mesa-egl/libGLESv2.so

wget http://old-releases.ubuntu.com/ubuntu/pool/main/m/mesa/libglapi-mesa_7.11-0ubuntu3.2_amd64.deb
unar libglapi-mesa_7.11-0ubuntu3.2_amd64.deb
mkdir libglapi-mesa
tar --lzma -C libglapi-mesa -xvpf libglapi-mesa_7.11-0ubuntu3.2_amd64/data.tar.lzma
cp libglapi-mesa/usr/lib/x86_64-linux-gnu/libglapi.so.0.0.0  /usr/lib/x86_64-linux-gnu/.

pip3 install tensorflow
export LIBGL_ALWAYS_SOFTWARE=1
export QT_XCB_FORCE_SOFTWARE_OPENGL=1
#bazel test tensorflow_graphics/rendering/opengl:rasterizer_op_test --crosstool_top=//third_party/preconfig/ubuntu16.04/gcc7_manylinux2010-nvcc-cuda10.1:toolchain
bazel build tensorflow_graphics/rendering/opengl:rasterizer_op.so --crosstool_top=//third_party/preconfig/ubuntu16.04/gcc7_manylinux2010-nvcc-cuda10.1:toolchain
cp bazel-bin/tensorflow_graphics/rendering/opengl/rasterizer_op.so tensorflow_graphics/rendering/opengl/rasterizer_op.so