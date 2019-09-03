#!/bin/bash # shell type

#===========================================================================
# Execute this script: sh sub_pt2tracer.sh
#===========================================================================

Directory="/nethome/yxl1496/HYCOM"

Tracer=10

carryTracer=0 # 0 no cary; 1 2 3 different init distribution 

subsample=1

if [ $subsample = '0' ]; then
  sampRtioDe=1
else
  sampRtioDe=1.5  # denominator of sampRtio
fi

IndSampTemp=$(echo "10 * $sampRtioDe"|bc)  # multiply 10
IndSamp=${IndSampTemp%.*}  # then only integer

# copy codes into temporary m file
cat "$Directory/ptcls2tracers.m" >> trac$Tracer\_samp$IndSamp\_carry$carryTracer.m 

#replace indTracerSh in mfile with Tracer
sed -i "s#indTracerSh#$Tracer#g" trac$Tracer\_samp$IndSamp\_carry$carryTracer.m   

#replace subsampleSh in mfile with subsample
sed -i "s#subsampleSh#$subsample#g" trac$Tracer\_samp$IndSamp\_carry$carryTracer.m 

#replace sampRtioSh in mfile with sampRtio
sed -i "s#sampRtioDeSh#$sampRtioDe#g" trac$Tracer\_samp$IndSamp\_carry$carryTracer.m   

#replace carryTracerSh in mfile with carryTracer
sed -i "s#carryTracerSh#$carryTracer#g" trac$Tracer\_samp$IndSamp\_carry$carryTracer.m   

# submit job to cluster
bsub -J trc$Tracer\sp$IndSamp\cy$carryTracer -P ome -o pt.o%J -e pt.e%J -W 2:20 -q parallel -n 16 -R "rusage[mem=25000] span[ptile=16]" matlab -r trac$Tracer\_samp$IndSamp\_carry$carryTracer

