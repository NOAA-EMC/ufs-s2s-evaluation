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
    
    hardcopy=no           # yes | no

    exp1=ufs_p6
    exp2=ufs_p7
   
    whereexp=$noscrub/Models/
    res=Orig
    res=1p00

    nplots=3

# The script is  prepared to handle variables on the list below 
    oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx tsoil12m soilm02m sfcr speed spfh2m u850 v850 z500 u200 v200 cloudtot) 

      for varname in tsoil12m soilm02m ; do

        case "${oknames[@]}" in 
                *"$varname"*)  ;; 
                *)
             echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
             exit
        esac
        for season in DJF ; do
            for domain in Global   ; do    
                echo "Attempting $domain $season $varname "
                bash  map_compare_noobs.sh varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 d1=0 d2=0 whereexp=$whereexp nplots=$nplots res=$res ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep
            done
        done
    done

