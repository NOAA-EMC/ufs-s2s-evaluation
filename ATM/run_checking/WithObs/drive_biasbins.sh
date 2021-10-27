#!/bin/bash -l
#SBATCH -A fv3-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30
#
#
module load intel
module load ncl

    
    whereexp=$noscrub/Models
    whereobs=$noscrub/ReferenceData
    
    hardcopy=no                        # yes | no

    ystart=2012; yend=2012

    mstart=1; mend=12; mstep=1

    exp1=ufs_p6
    exp2=ufs_p7

    domain=GlobalTropics                   # Global | Global50 | GlobalTropics | Nino3.4 | NAM | CONUS 
    #domain=Global20
    #domain=NP
    #season=AllAvailable               # DJF | MAM | JJA | SON | AllAvailable 
    domain=CONUS
    season=DJF
    reference=gefs12r
    

# The scripts are prepared to handle variables on the list below 
    oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx )

    #for varname in tmpsfc prate ulwrftoa t2min t2max; do

 for season in $season ; do
     bash biasbins.sh whereexp=$whereexp whereobs=$whereobs varModel="tmp2m" reference=$reference domain=CONUS hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep mask=landonly
 done

