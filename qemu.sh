#!/bin/bash

qemu-system-x86_64 -drive file=out/linux.iso,format=raw -m 1G
