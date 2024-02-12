#!/bin/bash

# run to generate *.param files from instances.txt
# parallel bash mkInstances.sh ::: $(seq -w 2 30) ::: 0050 $(seq -w 200 200 2000)

echo "language Essence 1.3" >  ${1}-${2}.param
echo ""                     >> ${1}-${2}.param
echo "letting n be ${1}"    >> ${1}-${2}.param
echo "letting o be ${2}"    >> ${1}-${2}.param
echo ""                     >> ${1}-${2}.param

