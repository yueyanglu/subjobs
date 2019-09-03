#!/bin/bash # shell type

#===========================================================================
# Execute this script: sh sub_ptclsonly.sh
#===========================================================================

Directory="/nethome/yxl1496/HYCOM/subjobs"

  for ((loop=22; loop<=30; loop=loop+1)); do
    #copy codes into temporary m file
    cat "$Directory/run_ptclsonly.m" >> pt4_$loop.m

    #replace loop_s in mfile with $loop
    sed -i "s#loop_s#$loop#g" pt4_$loop.m 

    # name
    bsub -J pt4_$loop -P ome -o pt.o%J -e pt.e%J -W 60:00 -q general -n 1 -R "rusage[mem=18000]" matlab -r pt4_$loop
  done
