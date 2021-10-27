#!/bin/bash -l
#SBATCH -A fv3-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of yesdes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30

module load intel
module load ncl

    ystart=2011; yend=2018;  ystep=1
    mstart=1;    mend=12;    mstep=1
    dstart=1;    dend=15;     dstep=14

    hardcopy=yes           # yes | no
    hardcopy=no


    exp1=ufs_p6
    exp2=ufs_p7
    
    whereexp=$noscrub/Models/
    res=1p00
    res=Orig
    nplots=3


# The script is  prepared to handle variables on the list below 
    oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx soilm02m sfcr)

    # for varname in snod pres cloudlow cloudbdry cloudmid cloudhi dswrf uswrf dlwrf ulwrf tmpsfc tmp2m t2min t2max ulwrftoa pwat icec icetk lhtfl shtfl prate; do
     #for varname in icec icetk lhtfl shtfl ; do
     #for varname in prate ; do
      for varname in icec icetk ; do #cloudlow cloudhi cloudbdry icetk tmp2m tmpsfc ulwrftoa dswrf dlwrf snod ; do

        case "${oknames[@]}" in 
                *"$varname"*)  ;; 
                *)
             echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
             exit
        esac
       for domain in NH ; do
            #for season in DJF MAM JJA SON ; do
            for season in AllAvailable  ; do
                echo "Attempting $domain $season $varname "
                bash  map_compare_noobs_polar.sh varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 d1=0 d2=0 whereexp=$whereexp nplots=$nplots res=$res ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep
            done
        done
    done

