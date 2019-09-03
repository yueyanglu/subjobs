#!/bin/bash # shell type

#===========================================================================
# Execute this script: sh sub_rtdp.sh
#===========================================================================

Directory="/nethome/yxl1496/HYCOM/subjobs"
coarse=( '_smday45_D002_499' '_smday1_D002_499' '_dy1dy45_D002_499' \
         '_smdeg1_D002_499' '_smdeg02_D002_499' '_dg02dg1_D002_499' \
         '_smday45_smdeg1_D002_499' '_smday1_smdeg02_D002_499' '_dy1dg02_dy45dg1_D002_499' \
         '_geostr_D002_499')
# 1 for auto, 2 for spread
wichmethdSH=2

for coarse_id in {1..1}; do
  subcs=${coarse[coarse_id]:0:8}

  for ((loop=27; loop<=27; loop=loop+1)); do

    if [ $wichmethdSH = '1' ]; then
      #copy codes into temporary m file
      cat "$Directory/run_rtdp.m" >> rt_$loop$subcs.m

      #replace wichFrmSh in m file with wichmethdSH
      sed -i "s#wichFrmSh#$wichmethdSH#g" rt_$loop$subcs.m

      #replace coarse_file in m file with coarse
      sed -i "s#coarsefile#${coarse[coarse_id]}#g" rt_$loop$subcs.m

      #replace loop_s in mfile with $loop
      sed -i "s#loop_s#$loop#g" rt_$loop$subcs.m 

      # name
      bsub -J r${coarse[coarse_id]:3:5}_$loop -P ome -o rt.o%J -e rt.e%J -W 13:00 -q general -n 1 -R "rusage[mem=17000]" matlab -r rt_$loop$subcs
   else
      #copy codes into temporary m file
      cat "$Directory/run_rtdp.m" >> dp_$loop$subcs.m

      #replace wichFrmSh in m file with wichmethdSH
      sed -i "s#wichFrmSh#$wichmethdSH#g" dp_$loop$subcs.m

      #replace coarse_file in m file with coarse
      sed -i "s#coarsefile#${coarse[coarse_id]}#g" dp_$loop$subcs.m

      #replace loop_s in mfile with $loop
      sed -i "s#loop_s#$loop#g" dp_$loop$subcs.m 

      # name
      bsub -J d${coarse[coarse_id]:3:5}_$loop -P ome -o dp.o%J -e dp.e%J -W 44:00 -q general -n 1 -R "rusage[mem=17000]" matlab -r dp_$loop$subcs
    fi

   done
done


