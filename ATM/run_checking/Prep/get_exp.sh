#!/bin/bash 
#SBATCH --ntasks=1 -p service 
#SBATCH -A fv3-cpu
#SBATCH -t 12:00:00 
#SBATCH -q batch 
##SBATCH -q debug 
##SBATCH -t 30
#SBATCH -o /scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/slurm-getP8-%j.out
##SBATCH -q debug
#SBATCH -J p8

module load hpss
rundir=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/ufs_hr2/
cd $rundir

# Winter set
startdate=20191203
enddate=20200315

# Summer set
#startdate=20200601
#enddate=20200831

idate=$startdate
monthur=()

# Go every 3 days
while [ $idate -le $enddate ] ; do
   monthur+=( "$idate" )
   idate=$(date -d "$idate + 3 days" "+%C%y%m%d")
done

for tag in ${monthur[@]} ; do

     base=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS2/HR2/Winter/${tag}00
     #base=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS2/HR2/Summer/${tag}00

     hsi ls $base  > /dev/null 2>&1 #list and redirect to trash; all we care about is the comand status below
     base_exist=$?   # status is 0 if the directory on HPSS exist

     if [ $base_exist = 0 ]; then 
        echo working on $tag
        mkdir -p $rundir/$tag
        cd $rundir/${tag}
        echo $rundir/${tag}
        for fh in {3..384..3} ; do 
           fh3=$(printf "%03d" $fh)
           pgrb=./gfs.${tag}/00/atmos/gfs.t00z.pgrb2.1p00.f$fh3
           flux1p00=./gfs.${tag}/00/atmos/gfs.t00z.flux.1p00.f$fh3
           sflux=./gfs.${tag}/00/atmos/gfs.t00z.sfluxgrbf${fh3}.grib2

           if [ ! -f $flux1p00 ] ; then
              echo ${rundir}/${tag}/$flux1p00 does not exist
              htar -xvf $base/gfs_flux_1p00.tar $flux1p00
              echo htar -xvf $base/gfs_flux_1p00.tar $flux1p00
           fi
           #if [ ! -f  $sflux ]; then
           #   htar -xvf $base/gfs_flux.tar $sflux
           #   echo htar -xvf $base/gfs_flux.tar $sflux
           #fi
           if [ ! -f  $pgrb ]; then
              htar -xvf $base/gfsb.tar $pgrb 
              echo htar -xvf $base/gfsb.tar $pgrb 
           fi
        # htar -xvf $base/gfsa.tar  ./gfs.${tag}/00/atmos/gfs.t00z.pgrb2.0p25.f$fh3
        # htar -xvf $base/gfs_netcdfb.tar  ./gfs.${tag}/00/atmos/gfs.t00z.atmf${fh3}.nc
        # htar -xvf $base/gfs_netcdfb.tar  ./gfs.${tag}/00/atmos/gfs.t00z.sfcf${fh3}.nc
        done
     else
        echo $base does not yet exist
     fi
done
