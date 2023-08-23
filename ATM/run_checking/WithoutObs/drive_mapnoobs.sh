#!/bin/bash -l
#SBATCH -A fv3-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of yesdes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30

module load intel/2020
module load ncl


startdate=20191203
enddate=20200830

    hardcopy=yes           # yes | no
    #hardcopy=no           # yes | no

    exp1=ufs_hr1
    exp2=ufs_hr2_test
   
    whereexp=$noscrub1/Models/


    res=Orig
    res=1p00

    nplots=1

# The script is  prepared to handle variables on the list below 
    oknames=(land sst tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate \
            pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl \ 
            shtfl pres u10 tsoil12m soilm02m spfh2m u850 z500 u200  cloudtot sbsno tsoil010cm soilw010cm gflux albdo hpbl CAPE ustar gust rh850 rh1000)  

      for season in  AllAvailable ; do
      #for season in  DJF JJA ; do
        for varname in  sst t2min t2max tmpsfc tmp2m  icetk pwat icec cloudtot cloudbdry cloudlow cloudmid cloudhi spfh2m hpbl snod weasd tsoil010cm \
                                   soilw010cm lhtfl shtfl gflux dlwrf dswrf ulwrf uswrf ulwrftoa prate CAPE u850 z500 u200 u10 pres albdo rh1000 rh850 ; do 
        case "${oknames[@]}" in 
                *"$varname"*)  ;; 
                *)
             echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
             exit
        esac
            for domain in Global   ; do    
                echo "Attempting $domain $season $varname "

                d1=0; d2=6  # week1
                bash  map_compare_noobs.sh varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 d1=$d1 d2=$d2 whereexp=$whereexp nplots=$nplots res=$res startdate=$startdate enddate=$enddate
                d1=7; d2=13 # week2
                bash  map_compare_noobs.sh varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 d1=$d1 d2=$d2 whereexp=$whereexp nplots=$nplots res=$res startdate=$startdate enddate=$enddate

                done
            done
        done

