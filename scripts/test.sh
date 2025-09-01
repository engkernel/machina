#!/bin/bash

make clean
make
qemu-system-x86_64 -m 4G -drive format=raw,file=build/machina.bin
