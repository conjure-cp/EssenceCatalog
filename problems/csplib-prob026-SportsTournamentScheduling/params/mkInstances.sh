#!/bin/bash

# run to generate *.param files from instances.txt
# gseq -f'%02g' 1 10 | bash mkInstances.sh

COMMAND=$( cat <<EOF
echo "language Essence 1.3" >   {1}.param ;
echo ""                     >>  {1}.param ;
echo "letting n_teams be {1}"     >>  {1}.param ;
echo ""                     >>  {1}.param
EOF
)

parallel --colsep ' ' $COMMAND

