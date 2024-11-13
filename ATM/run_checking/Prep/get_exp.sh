#!/bin/bash 
#SBATCH --ntasks=1 -p service 
#SBATCH -A fv3-cpu
#SBATCH -t 12:00:00 
#SBATCH -q batch 
##SBATCH -q debug 
##SBATCH -t 30
#SBATCH -o slurm-getHR4-%j.out
##SBATCH -q debug
#SBATCH -J hr4

module load hpss
exp=ufs_hr4
rundir=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/$exp
mkdir -p $rundir
cd $rundir

# Winter set
startdate=20200129
enddate=20200228
# summer set
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

     base=/NCEPDEV/emc-climate/5year/role.ufscpara/WCOSS2/HR4/winter/${tag}00
     #base=/NCEPDEV/emc-climate/5year/role.ufscpara/WCOSS2/HR4/summer/${tag}00


     hsi ls $base  > /dev/null 2>&1 #list and redirect to trash; all we care about is the comand status below
     base_exist=$?   # status is 0 if the directory on HPSS exist

     if [ $base_exist = 0 ]; then 
        echo working on $tag
        mkdir -p $rundir/$tag
        cd $rundir/${tag}
        echo $rundir/${tag}
        for fh in {0..384..6} ; do 
           fh3=$(printf "%03d" $fh)

           flux1p00=gfs.$tag/00/products/atmos/grib2/1p00/gfs.t00z.flux.1p00.f${fh3}
           pgrb1p00=gfs.$tag/00/products/atmos/grib2/1p00/gfs.t00z.pgrb2.1p00.f${fh3}
           sflux=gfs.${tag}/00/model_data/atmos/master/gfs.t00z.sfluxgrbf${fh3}.grib2
           pgrb=gfs.${tag}/00/products/atmos/grib2/0p25/gfs.t00z.pgrb2.0p25.f${fh3}

           if [ ! -f $flux1p00 ] ; then
              echo ${rundir}/${tag}/$flux1p00 does not exist
              htar -xvf $base/gfs_flux_1p00.tar $flux1p00
              echo htar -xvf $base/gfs_flux_1p00.tar $flux1p00
           fi
           if [ ! -f  $pgrb1p00 ]; then
              htar -xvf $base/gfsb.tar $pgrb1p00 
              echo htar -xvf $base/gfsb.tar $pgrb1p00 
           fi
        done
     else
        echo $base does not yet exist
     fi
done
