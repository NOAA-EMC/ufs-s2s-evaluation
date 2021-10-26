#!/bin/bash -l
#SBATCH -A fv3-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30
#
#
# This is a tiny little package that compares two sets of (exp1 and exp2) for a chosen variable, domain, season
# top directory with preprocessed files 

    whereexp=$noscrub/Models
    whereobs=$noscrub/ReferenceData
    
    hardcopy=no                        # yes | no

    ystart=2011; yend=2018
    mstart=1; mend=12; mstep=1
    dstart=1; dend=15; dstep=14

    exp1=ufs_p6
    exp2=ufs_p7
    reference=era5
    reference=gefs12r

# The scripts are prepared to handle variables on the list below 
    oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate cloudtot u200 u850 z500 )

 for domain in CONUS ; do #Nino34 GlobalTropics Global ; do
 for season in DJF; do
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=tmp2m reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=cloudtot reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=cloudtot reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=oceanonly
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=dlwrf reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=ulwrf reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=dswrf reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=uswrf reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
    # bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=z500 reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
    # bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=u850 reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
    # bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=u200 reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
    # bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=tmp2m reference=$reference domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
#     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=ulwrftoa domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
#     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=tmpsfc domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=oceanonly
#     bash pdf.sh whereexp=$whereexp whereobs=$whereobs varModel=prate domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
 done
 done


