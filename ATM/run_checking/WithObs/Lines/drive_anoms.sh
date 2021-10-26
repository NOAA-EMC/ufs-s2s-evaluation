#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 25                # -t specifies walltime in minutes; if in debug, cannot be more than 30
#
    # Start/end delimiters for initial conditions

        ystart=2012; yend=2012;  ystep=1
        mstart=1;    mend=12;    mstep=1
        dstart=1;    dend=15;     dstep=14

    # Name and location of experiment and obs (data as 35-day time series in netcdf)

        obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/    # Location of OBS: changing it is not recommended
        exp_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/            # Location of OBS: changing it is not recommended
        whereexp=$exp_root
        whereobs=$obs_root

        exp_old=ufs_p6
        exp_new=ufs_p7
        res=1p00

    # Other specitications

        hardcopy=no         # Valid choices are yes no      

    #  reference: Valid choices are era5, cfsr, or gefs12r (only applies to z500, u200, u850, tmp2m
    #             Defaults to era5 if not specified

        reference=gefs12r      

    # var: Valid choices for comparison with OBS are: 
    # tmpsfc, prate, ulwrftoa, tmp2m, t2min, t2max, z500, u200, u850 cloudtot, dswrf, uswrf, dlwrf, dswrf
 
        declare -a varlist=("cloudtot" "dswrf" "tmp2m" "z500")   

    # season: Valid choices are "DJF" "MAM" "JJA" "SON" "AllAvailable"
        declare -a seasonlist=( "AllAvailable")     

    # domain: Valid choices are Global Nino34 GlobalTropics
       
        declare -a domainlist=("Global")
  
    # mask: Valid choices are nomask, oceanonly, landonly. Defaults to "nomask" if not specified. 
        
        mask="oceanonly"
        mask="nomask"

    for season in "${seasonlist[@]}" ; do
        for domain in "${domainlist[@]}" ; do
            for varname in "${varlist[@]}" ; do
                bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain \
                                hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new \
                                ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep \
                                dstart=$dstart dend=$dend dstep=$dstep mask=$mask reference=$reference

            done
        done
    done


