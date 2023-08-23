#!/bin/bash -l
#SBATCH -A marine-cpu
#SBATCH --job-name=p8c_upper
#SBATCH --partition=hera
#SBATCH --ntasks=1 -p service
#SBATCH -q batch
#SBATCH -t 08:00:00                 # if in debug, cannot be more than 00:30:00
##SBATCH -q debug
##SBATCH -t 00:30:00                 # if in debug, cannot be more than 00:30:00
#SBATCH --nodes=1

    # Start/end delimiters for initial conditions

      startdate=20191203
      enddate=20200831

    # Name and location of experiment output on HPSS

       
        exp_new=ufs_hr2_test
        upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/ufs_hr2_test/        # specify location of  grib2 files uploaded from HPSS

        #exp_new=ufs_hr1
        #upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/ufs_hr1/        # specify location of  grib2 files uploaded from HPSS

        exp_root=/scratch1/NCEPDEV/climate/Lydia.B.Stefanova/Models/                   # store preprocessed data here

        res=Orig                                                                       # Orig: use sfluxgrb
        res=1p00                                                                       # 1p00: use flux.1p00 and pgrb.1p00


    # Specify list of variables to preprocess (turn from 6-hourly grib2 into a 35-day series of daily netcdf); 
        declare -a varlist_upper=("CAPE" "u850" "z500" "u200" "rh850" "rh1000")
        declare -a varlist_surface=("land" "sst" "tmpsfc" "tmp2m" "t2min" "t2max" "ulwrftoa" "snow" "snod" "weasd" "dswrf" "dlwrf" "uswrf" "ulwrf" "cloudtot" "cloudbdry" "cloudlow" "cloudmid" "cloudhi" "icetk" "icec" "prate" "pwat" "spfh2m" "tsoil010cm" "soilw010cm" "weasd" "snow" "gflux" "sfexc" "lhtfl" "shtfl" "sbsno" "hpbl"  "soill010cm"  "u10" "v10" "soilw010cm")
        #declare -a varlist_surface=("sst")
    # The plotting scripts are prepared to handle variables on the list below:

        oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx tsoil12m soilm02m sfcr spfh2m u850 v850 z500 u200 v200 cloudtot vgtyp sbsno tsoil010cm soilw010cm gflux sfexc albdo hpbl CAPE sst ustar gust rh850 rh1000 cprat soill010cm)

#====================================================================================================
for exp in $exp_new ; do
    wherefrom=${upload_root}/  #${exp}
    whereto=${exp_root}/${exp}/${res}
    mkdir -p $whereto
    for varname in ${varlist_surface[@]} ; do
        case "${oknames[@]}" in 
             *"$varname"*)  ;; 
             *)
             echo "Exiting. To continue, please correct: plotting not implemented for variable ---> $varname <---"
             exit
        esac
        bash preprocess.sh exp=$exp varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res startdate=$startdate enddate=$enddate ftype="surface"
    done
    for varname in ${varlist_upper[@]} ; do
        case "${oknames[@]}" in
             *"$varname"*)  ;;
             *)
             echo "Exiting. To continue, please correct: plotting not implemented for variable ---> $varname <---"
             exit
        esac
        bash preprocess.sh exp=$exp varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res startdate=$startdate enddate=$enddate ftype="upper"  
    done
done


