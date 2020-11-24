
Contents: 

plot_mom6.py 
   - Plots any variable from MOM6 native tripolar netcdf files 
   - ./plot_mom6.py -h for usage 
   - note, uses a fixed MLD_003 colorbar range, other vars use min/max of file


plot_mom6_diff.py
   - Plots differences of any two MOM6 file variables + percentage difference 
   - ./plot_mom6_diff.py -h for usage 

plot_mom6_diff_ostia.py
   - Plots difference of MODEL-OSTIA 
   - ./plot_mom6_diff_ostia.py -h for usage 
   - Note grib2 files are expected to be converted to netcdf at this time 

plot_mom6_diff_mlddata.py 
   - Plots difference of MODEL - MLD(data)
   - ./plot_mom6_diff_mlddata.py -h for usage 
   - Data is expected in the form of (/scratch2/NCEPDEV/climate/Jessica.Meixner/Data/analysis/MLD/mld_DR003_c1m_reg2.0.nc) de Boyer Montégut et al. 2004


Preprocessing data: 
   - Some of the above scripts need preprocessed data (or optionally can use preprocessed data). 
     Some useful information is below

   - Averages of files can be taken by using nco command: 
         (First: module load intel nco)
         ncea files_to_avg_*.nc   averageoutputfile.nc
         or for a specific set of variables: 
         ncea -v var1,var2 files_to_avg_*.nc   averageoutputfile.nc
   - To convert SST and MLD from grib2 file to netcdf for comparisons with data: 
         (First: module load wgrib2) 
         wgrib2 ocn_ice_file.grb2 -s | egrep '(:TMP:|:DBSS:bottom of ocean mixed layer)' | wgrib2 -i ocn_ice_file.grb2 -grib small.ocn_ice_file.grb2
         wgrib2 small.ocn_ice_file.grb2 -netcdf new_ocn_ice_file.grb2netcdf.nc
   - To remap OSTIA data to 1/4 degree: 
         (First module load cdo) 
         cdo remapbil,r1440x721 OSTIA_orig_file.nc OSTIA_025.nc
   - To remap ocean (grib->netcdf) to 2 deg file for comparison with 2deg MLD data: 
         cdo remapbil,r180x91 ocn_grib2netcdf_0p25.nc ocn_fromgrib_2p0_newfile.nc


