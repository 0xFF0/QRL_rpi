#!/bin/bash

# Update and Upgrade packages
sudo apt update && sudo apt upgrade -y

# Install Required dependencies
sudo apt-get -y install swig4.0 python3-dev python3-pip build-essential pkg-config libssl-dev libffi-dev libhwloc-dev libboost-dev cmake git libleveldb-dev


# Make sure setuptools is the latest
pip3 install -U setuptools


# Qrandomx for pi4
git clone https://github.com/theQRL/qrandomx.git
git clone https://github.com/tevador/RandomX.git
mkdir qrandomx/deps/RandomX
cp -r RandomX/* qrandomx/deps/RandomX
cd qrandomx
sed -i 's/randomx_create_vm(flags | RANDOMX_FLAG_LARGE_PAGES/randomx_create_vm(flags/g' src/qrandomx/rx-slow-hash.c 
sed -i 's/ -msse2 -maes//g' CMakeLists.txt
sudo python3 setup.py install
cd ..


# Qryptonight for pi4
git clone https://github.com/theQRL/qryptonight.git
cd qryptonight
sed -i 's/ -msse2 -maes//g' CMakeLists.txt
sed -i 's/${REF_CRYPTONIGHT_SRC}//g' CMakeLists.txt
sed -i 's/xmr-stak/pycryptonight/g' CMakeLists.txt
sed -i 's/99)/11)/g' CMakeLists.txt
sed -i 's/xmrstak\/backend\/cpu\/crypto//g' CMakeLists.txt
cd ..
git clone https://github.com/ph4r05/py-cryptonight.git
mkdir qryptonight/deps/pycryptonight
cp py-cryptonight/src/cryptonight/* qryptonight/deps/pycryptonight
cd qryptonight/deps/pycryptonight
sed -i 's/void cn_fast_hash/#ifdef __cplusplus\nextern "C"{\n#endif\nvoid cn_fast_hash/g' hash-ops.h
sed -i 's/void tree_hash/#ifdef __cplusplus\n}\n#endif\n\/\//g' hash-ops.h 
sed -i '1s/^/#define NO_AES=1\n/' hash-ops.h 
sed -i '1s/^/#include <stdint.h>\n/' CryptonightR_JIT_x86_64.c
cd ../../src/qryptonight

cat <<EOF > qryptonight.cpp

#include "qryptonight.h"
#include <iostream>
#include "hash-ops.h"

Qryptonight::Qryptonight(){}

std::atomic_bool Qryptonight::_jconf_initialized { false };

void Qryptonight::init(){ }

Qryptonight::~Qryptonight(){}

std::vector<uint8_t> Qryptonight::hash(const std::vector<uint8_t>& input)
{
    std::vector<uint8_t> output(32);

    // cryptonight hash does not support less than 43 bytes
    const uint8_t minimum_input_size = 43;

    if (input.size()<minimum_input_size)
    {
        throw std::invalid_argument("input length should be > 42 bytes");
    }

    cn_slow_hash(input.data(), input.size(), (char*)output.data(), 1, 0, 0);
 
    return output;
};
EOF


cat <<EOF > qryptonight.h
#ifndef QRYPTONIGHT_QRYPTONIGHT_H
#define QRYPTONIGHT_QRYPTONIGHT_H

#include <vector>
#include <string>
#include <stdexcept>
#include <atomic>
#include "hash-ops.h"


class Qryptonight {
public:
    Qryptonight();
    virtual ~Qryptonight();

    bool isValid() { return true; } 

    std::vector<uint8_t> hash(const std::vector<uint8_t>& input);
    

protected:
    static void init();
    static std::atomic_bool _jconf_initialized;

};

#endif //QRYPTONIGHT_QRYPTONIGHT_H
EOF
cd ../..
sudo python3 setup.py install
cd ..

# Install QRL
git clone https://github.com/theQRL/QRL.git
cd QRL
sed -i 's/pyqryptonight/#pyqryptonight/g' setup.cfg
sed -i 's/pyqrandomx/#pyqrandomx/g' setup.cfg
sudo pip3 install service_identity
sudo python3 setup.py install

