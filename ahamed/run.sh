#!/bin/bash

export PATH="/util/gcc/bin:/home/csgrad/ahamed/bin:$PATH"
export LD_LIBRARY_PATH="/util/gcc/lib64:$LD_LIBRARY_PATH"

python exp.py
