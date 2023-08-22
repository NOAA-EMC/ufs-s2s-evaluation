#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q batch             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 120               # -t specifies walltime in minutes; if in debug, cannot be more than 30


for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            whereexp) whereexp=${VALUE} ;;
            hardcopy) hardcopy=${VALUE} ;;
            domain)   domain=${VALUE} ;;  
            varModel)  varModel=${VALUE} ;;   
            season)   season=${VALUE} ;;   
            nameModelA) nameModelA=${VALUE} ;;
            nameModelB) nameModelB=${VALUE} ;;
            d1) d1=${VALUE} ;;
            d2) d2=${VALUE} ;;
            nplots) nplots=${VALUE:-3} ;;
            res) res=${VALUE:-1p00} ;;
            startdate)    startdate=${VALUE};;
            enddate)      enddate=${VALUE};;
            *)
    esac


done

case "$domain" in 
    "Global") latS="-90"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "Nino3.4") latS="-5"; latN="5" ;  lonW="190" ; lonE="240" ;;
    "GlobalTropics") latS="-30"; latN="30" ;  lonW="0" ; lonE="360" ;;
    "Global50") latS="-50"; latN="50" ;  lonW="0" ; lonE="360" ;;
    "CONUS") latS="25"; latN="60" ;  lonW="210" ; lonE="300" ;;
    "NAM") latS="0"; latN="90" ;  lonW="180" ; lonE="360" ;;
    "NH") latS="50"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "SH") latS="-90"; latN="-60" ;  lonW="0" ; lonE="360" ;;
    *)
esac


nameModelBA=${nameModelB}_minus_${nameModelA}
       if [ "$varModel" == "sfcr" ] ; then
          ncvarModel="SFCR_surface"; multModel=1; offsetModel=0.; units="m"; mask="oceanonly"
       fi
       if [ "$varModel" == "soilm02m" ] ; then
          ncvarModel="SOILM_0M2mbelowground"; multModel=1; offsetModel=0.; units="kg/m^2"; mask="landonly"
       fi
       if [ "$varModel" == "pres" ] ; then
          ncvarModel="PRES_surface"; multModel=0.01; offsetModel=0.; units="mb"; mask="nomask"
       fi
       if [ "$varModel" == "t2max" ] ; then
          ncvarModel="TMAX_2maboveground"; multModel=1.; offsetModel=0.; units="deg K"; mask="landonly"
          mask="nomask"
       fi
       if [ "$varModel" == "t2min" ] ; then
          ncvarModel="TMIN_2maboveground"; multModel=1.; offsetModel=0.; units="deg K";mask="landonly"
          mask="nomask"
       fi
       if [ "$varModel" == "tmp2m" ] ; then
          ncvarModel="TMP_2maboveground"; multModel=1.; offsetModel=0.; units="deg K";mask="landonly"
       fi
       if [ "$varModel" == "tmpsfc" ] ; then
          ncvarModel="TMP_surface"; multModel=1.; offsetModel=0.; units="deg K";mask="oceanonly"
       fi
       if [ "$varModel" == "shtfl" ] ; then
          ncvarModel="SHTFL_surface"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "prate" ] ; then
          ncvarModel="PRATE_surface"; multModel=86400.; offsetModel=0.; units="mm/day"; mask="nomask"
       fi
       if [ "$varModel" == "lhtfl" ] ; then
          ncvarModel="LHTFL_surface"; multModel=0.03456; offsetModel=0.; units="mm/day"; mask="nomask"
       fi
       if [ "$varModel" == "pwat" ] ; then
           ncvarModel="PWAT_entireatmosphere_consideredasasinglelayer_"; multModel=1.; offsetModel=0.; units="kg/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "cloudhi" ] ; then
           ncvarModel="TCDC_highcloudlayer"; multModel=1.; offsetModel=0.; units="percent"; mask="nomask"
       fi
       if [ "$varModel" == "cloudmid" ] ; then
        ncvarModel="TCDC_middlecloudlayer"; multModel=1.; offsetModel=0.; units="percent"; mask="nomask"
       fi
       if [ "$varModel" == "cloudlow" ] ; then
           ncvarModel="TCDC_lowcloudlayer"; multModel=1.; offsetModel=0.; units="percent"; mask="nomask"
       fi
       if [ "$varModel" == "cloudbdry" ] ; then
           ncvarModel="TCDC_boundarylayercloudlayer"; multModel=1.; offsetModel=0.; units="percent"; mask="nomask"
       fi
       if [ "$varModel" == "cloudtot" ] ; then
           ncvarModel="TCDC_entireatmosphere"; multModel=1.; offsetModel=0.; units="percent"
       fi
       if [ "$varModel" == "ulwrftoa" ] ; then
           ncvarModel="ULWRF_topofatmosphere"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "dlwrf" ] ; then
           ncvarModel="DLWRF_surface"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "dswrf" ] ; then
           ncvarModel="DSWRF_surface"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "uswrf" ] ; then
           ncvarModel="USWRF_surface"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "ulwrf" ] ; then
           ncvarModel="ULWRF_surface"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
       fi
       if [ "$varModel" == "snow" ] ; then
           ncvarModel="SNOWC_surface"; multModel=1.; offsetModel=0.; units="percent"; mask="nomask"
       fi
       if [ "$varModel" == "snod" ] ; then
           ncvarModel="SNOD_surface"; multModel=1.; offsetModel=0.; units="m"; mask="nomask"
       fi
       if [ "$varModel" == "weasd" ] ; then
           ncvarModel="WEASD_surface"; multModel=1.; offsetModel=0.; #units="m"; mask="nomask"
       fi
       if [ "$varModel" == "icetk" ] ; then
           ncvarModel="ICETK_surface"; multModel=1.; offsetModel=0.; units="m"; mask="nomask"
       fi
       if [ "$varModel" == "icec" ] ; then
           ncvarModel="ICEC_surface"; multModel=100.; offsetModel=0.; units="percent"; mask="nomask"
       fi
    
       mask="oceanonly"
       mask="nomask"

       rm -f ${varModel}-${nameModelA}-list.txt ${varModel}-${nameModelB}-list.txt    # clean up from last time

       LENGTH=0
       pass=0
idate=$startdate
monthur=()

# Days with output: monthur

while [ $idate -le $enddate ] ; do
   monthur+=( "$idate" )
   idate=$(date -d "$idate + 3 days" "+%C%y%m%d")
done

# Loop through days with output
for tag in ${monthur[@]} ; do
           if [ -f $whereexp/$nameModelA/${res}/dailymean/${tag}/${varModel}.${nameModelA}.${tag}.dailymean.${res}.nc ] ; then
              if [ -f $whereexp/$nameModelB/${res}/dailymean/${tag}/${varModel}.${nameModelB}.${tag}.dailymean.${res}.nc ] ; then

                 case "${season}" in
                      *"DJF"*)
                          if [ $mm1 -ge 12 ] || [ $mm1 -le 2 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/${res}/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.${res}.nc >> ${varModel}-${nameModel}-list.txt
                             done
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"MAM"*)
                          if [ $mm1 -ge 3 ] && [ $mm1 -le 5 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/${res}/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.${res}.nc >> ${varModel}-${nameModel}-list.txt
                             done
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"JJA"*)
                          if [ $mm1 -ge 6 ] && [ $mm1 -le 8 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/${res}/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.${res}.nc >> ${varModel}-${nameModel}-list.txt
                             done
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"SON"*)
                          if [ $mm1 -ge 9 ] && [ $mm1 -le 11 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/${res}/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.${res}.nc >> ${varModel}-${nameModel}-list.txt
                             done
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"AllAvailable"*)
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/${res}/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.${res}.nc >> ${varModel}-${nameModel}-list.txt
                             done
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                      ;;
                 esac

              fi
           fi
       done

   truelength=$LENGTH
   if [ $LENGTH -eq 1 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                              cat ${varModel}-${nameModel}-list.txt ${varModel}-${nameModel}-list.txt > tmp.txt
                              mv tmp.txt ${varModel}-${nameModel}-list.txt
                             done
                              cat ${varModel}-${nameObs}-list.txt ${varModel}-${nameObs}-list.txt > tmp.txt
                              mv tmp.txt ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
   fi
   echo "A total of $truelength ICs are being processed"

   LENGTHm1="$(($LENGTH-1))"                        # Needed for counters starting at 0
   s1=0; s2=$LENGTHm1 ; startname="${LENGTH}ICs"  # Glom together all ICs
   #d1=0; d2=34                                      # from day=d1 to day=d1 (counter starting at 0)
   d1p1="$(($d1+1))"                                #  (counter starting at 1)
   d2p1="$(($d2+1))"

###################################################################################################
#                                            Create ncl script
###################################################################################################

echo $iclist
nclscript="map_${season}.polar.ncl"                         # Name for the NCL script to be created
cat << EOF > $nclscript

  if isStrSubset("$hardcopy","yes") then
     wks_type                     = "png"
     wks_type@wkWidth             = 3000
     wks_type@wkHeight            = 3000
  else
     wks_type                     = "x11"
     wks_type@wkWidth             = 1200
     wks_type@wkHeight            = 800
  end if 

  wks                          = gsn_open_wks(wks_type,"${varModel}.${nameModelB}.vs.${nameModelA}.${season}.${startname}.$domain.d${d1p1}-d${d2p1}")

  latStart=${latS}
  latEnd=${latN}
  lonStart=${lonW}
  lonEnd=${lonE}

  if isStrSubset("$domain","Global") then
     lonStart=60
     lonEnd=420
  end if


  ${nameModelA}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelA}-list.txt }") 
  ${nameModelB}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelB}-list.txt }") 

  ${nameModelA}_add = addfiles (${nameModelA}_list, "r")   ; note the "s" of addfile
  ${nameModelB}_add = addfiles (${nameModelB}_list, "r")   

  maskMod=addfile("$whereexp/${nameModelA}/${res}/dailymean/20120101/land.${nameModelA}.20120101.dailymean.${res}.nc", "r")
  masker=maskMod->LAND_surface(0,{${latS}:${latN}},{${lonW}:${lonE}})
  ;masker=where(masker.lt.1,masker,masker@_FillValue)
  masker=where(masker.ne.1,masker,masker@_FillValue)


;---Read variables in "join" mode and print a summary of the variable

  ListSetType (${nameModelA}_add, "join") 
  ListSetType (${nameModelB}_add, "join") 
   
  ${nameModelA}_lat_0=${nameModelA}_add[:]->latitude
  ${nameModelA}_lon_0=${nameModelA}_add[:]->longitude

  nameA=getfilevarnames(${nameModelA}_add[0])
  nameB=getfilevarnames(${nameModelB}_add[0])

  ${nameModelA}_fld = ${nameModelA}_add[:]->\$nameA(4)\$
  ${nameModelB}_fld = ${nameModelB}_add[:]->\$nameB(4)\$

  ;${nameModelA}_fld = ${nameModelA}_add[:]->${ncvarModel}
  ;${nameModelB}_fld = ${nameModelB}_add[:]->${ncvarModel}


  lat_0 = ${nameModelA}_lat_0(0,{${latS}:${latN}})
  lon_0 = ${nameModelA}_lon_0(0,{${lonW}:${lonE}})
  nlon=dimsizes(lon_0)
  nlat=dimsizes(lat_0)

; Mean maps

  ;${nameModelA}_fld=where(${nameModelA}_fld.ge.-20,${nameModelA}_fld,${nameModelA}_fld@_FillValue)
  ${nameModelA}_mean=dim_avg_n_Wrap(${nameModelA}_fld($s1:$s2,$d1:$d2,{${latS}:${latN}},{${lonW}:${lonE}}),(/0,1/))
  ${nameModelB}_mean=dim_avg_n_Wrap(${nameModelB}_fld($s1:$s2,$d1:$d2,{${latS}:${latN}},{${lonW}:${lonE}}),(/0,1/))

  ${nameModelA}_mean=${nameModelA}_mean*${multModel} + 1.*($offsetModel)
  ${nameModelB}_mean=${nameModelB}_mean*${multModel} + 1.*($offsetModel)

  ${nameModelBA}_diff=${nameModelA}_mean
  ${nameModelBA}_diff=${nameModelB}_mean-${nameModelA}_mean

  denom=${nameModelA}_mean
  denom=where(${nameModelA}_mean.ge.0.01,${nameModelA}_mean,${nameModelA}_mean@_FillValue)

  ratio=${nameModelBA}_diff
  ratio=(${nameModelBA}_diff/denom)*100.

  if isStrSubset("$mask","landonly") then
    ${nameModelA}_mean=where(ismissing(masker),${nameModelA}_mean,${nameModelA}_mean@_FillValue)
    ${nameModelB}_mean=where(ismissing(masker),${nameModelB}_mean,${nameModelB}_mean@_FillValue)
    ${nameModelBA}_diff=where(ismissing(masker),${nameModelBA}_diff,${nameModelBA}_diff@_FillValue)
    ratio=where(ismissing(masker),ratio,ratio@_FillValue)
  end if 
  if isStrSubset("$mask","oceanonly") then
    ${nameModelA}_mean=where(.not.ismissing(masker),${nameModelA}_mean,${nameModelA}_mean@_FillValue)
    ${nameModelB}_mean=where(.not.ismissing(masker),${nameModelB}_mean,${nameModelB}_mean@_FillValue)
    ${nameModelBA}_diff=where(.not.ismissing(masker),${nameModelBA}_diff,${nameModelBA}_diff@_FillValue)
    ratio=where(.not.ismissing(masker),ratio,ratio@_FillValue)
  end if 

  ${nameModelA}_mean@units="$units"
  ${nameModelB}_mean@units="$units"
  ${nameModelBA}_diff@units="$units"
  ratio@units="percent"

; area average

  rad    = 4.0*atan(1.0)/180.0
  re     = 6371220.0
  rr     = re*rad

  dlon   = abs(lon_0(2)-lon_0(1))*rr
  dx     = dlon*cos(lat_0*rad)
  dy     = new ( nlat, typeof(dx))
  dy(0)  = abs(lat_0(2)-lat_0(1))*rr
  dy(1:nlat-2)  = abs(lat_0(2:nlat-1)-lat_0(0:nlat-3))*rr*0.5   
  dy(nlat-1)    = abs(lat_0(nlat-1)-lat_0(nlat-2))*rr
  weights2   = dx*dy 
  
   ;weights2  = new((/nlat, nlon/), typeof(${nameModelA}_mean))
   ;weights2  = conform (weights2, dydx, 0)

         opt=0  ; ignore missing values
         ${nameModelA}_aave=wgt_areaave_Wrap(${nameModelA}_mean, weights2,1.0, opt)
         ${nameModelB}_aave=wgt_areaave_Wrap(${nameModelB}_mean, weights2,1.0, opt)
         ${nameModelBA}_aave=wgt_areaave_Wrap(${nameModelBA}_diff, weights2,1.0, opt)
       
         amin=min(${nameModelBA}_diff)
         amax=max(${nameModelBA}_diff)

         tf=True  ;round off, not truncate
         ${nameModelA}_aave=decimalPlaces(${nameModelA}_aave,4,tf)
         ${nameModelB}_aave=decimalPlaces(${nameModelB}_aave,4,tf)
         ${nameModelBA}_aave=decimalPlaces(${nameModelBA}_aave,4,tf)
         amin=decimalPlaces(amin,4,tf)
         amax=decimalPlaces(amax,4,tf)


         ;print(${nameModelA}_aave)
         ;print(${nameModelB}_aave)
         ;print(${nameModelBA}_aave)
         
   

  ${nameModelA}_mean@long_name=${nameModelA}_mean@long_name + " " + "${nameModelA}" +"; mean=" + ${nameModelA}_aave
  ${nameModelB}_mean@long_name=${nameModelB}_mean@long_name + " " + "${nameModelB}" +"; mean=" + ${nameModelB}_aave
  ${nameModelBA}_diff@long_name="Difference" +"; mean=" + ${nameModelBA}_aave + "; min=" + amin + "; max=" + amax
  ratio@long_name="Percent Change"

  plot=new($nplots,graphic)

  res                     = True
  if (isStrSubset("$domain","CONUS").or.isStrSubset("$domain","NAM")) then
     res@gsnAddCyclic        = False
  end if
  res@gsnDraw             = False                          ; don't draw
  res@gsnFrame            = False                          ; don't advance frame

  res@gsnPolar            = "$domain"               ; specify the hemisphere
  res@mpMinLatF           = $latS                 ; specify min lat
  res@mpMaxLatF           = $latN                 ; specify min lat
  ;res@mpCenterLonF = -45
  res@mpCenterLonF = 180

  res@cnFillOn             = True               ; turns on the color
  res@mpFillOn             = False              ; turns off continent gray
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnFillMode          = "RasterFill"

  ;res@mpCenterLonF        = (lonStart+lonEnd)/2
  ;res@mpMinLatF           = latStart
  ;res@mpMaxLatF           = latEnd
  ;res@mpMinLonF           = lonStart
  ;res@mpMaxLonF           = lonEnd

  res@mpGridAndLimbOn        = True
  ;res@mpShapeMode            = "FreeAspect"
  res@vpWidthF               = 0.8
  res@vpHeightF              = 0.4
  res@mpGridLineDashPattern  = 5                  ; lat/lon lines dashed
  res@mpGridLatSpacingF      = 10
  res@mpGridLonSpacingF      = 30
  res@mpGridLineColor        = "Gray30"

  res@cnLevelSelectionMode="ManualLevels"

  res0=res
  res1=res
  res2=res

   if (isStrSubset("{$varModel}","sfcr")) then

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnFillPalette        = "BlueDarkRed18"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      ;res1@cnLevels             = (/ -10., -5., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 5., 10./)   ; set levels
      ;res1@cnLevels             = (/ -1e-1, -1e-2, -1e-3,-1e-4,-1e-5, -1e-6, -1e-7, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1/)   ; set levels

      ;res1@cnLevels             = (/  -1e-2, -1e-3,-1e-4,-1e-5, -1e-6, -1e-7, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2/)   ; set levels
      res1@cnLevels             = (/   -1e-2,-1e-3,-1e-4,-1e-5,-1e-8,1e-8,  1e-5, 1e-4, 1e-3,1e-2/)   ; set levels
      res1@lbLabelAutoStride = False
      res1@lbLabelAngleF=90

  end if 

  if (isStrSubset("{$varModel}","icetk")) then
      res0@cnFillPalette="CBR_wet"
       res0@cnFillPalette="prcp_1"
       res0@cnFillPalette="precip2_17lev"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      ;res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.3, 0.5,  1,  1.5, 2.,3. /)   ; set levels
      res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.3, 0.5,  1.,1.5, 2.,3. /)   ; set levels


      res1@cnFillPalette="precip_diff_12lev"
      res1@cnFillPalette="NCV_jaisnd"
      res1@cnFillPalette="BlAqGrWh2YeOrReVi22"
      res1@cnFillPalette="ViBlGrWhYeOrRe"

      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/   -1.,-0.5, -0.2,-0.1,-0.05, 0.05, 0.1, 0.2, 0.5 ,1.  /)   ; set levels
      ;res1@cnLevels             = (/   -1.,-0.5, -0.2,-0.1, 0.1, 0.2, 0.5 ,1.  /)   ; set levels

      res2@cnFillPalette="precip_diff_12lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels

  end if
  if (isStrSubset("{$varModel}","oldcloud")) then
       cmap=read_colormap_file("MPL_gnuplot")
       cmap = cmap(::-1,:)
       res0@cnFillPalette = cmap

       res0@cnMinLevelValF  = 10.
       res0@cnMaxLevelValF  = 90.
       res0@cnLevelSpacingF  = 10.

       res1@cnFillPalette        = "sunshine_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res1@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used


       res2=res1
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res2@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used
  end if
  if (isStrSubset("{$varModel}","cloud")) then
       cmap=read_colormap_file("MPL_gnuplot")
       cmap = cmap(::-1,:)
;       res0@cnFillPalette = cmap

;       res0@cnFillPalette="precip3_16lev"
       res0@cnFillPalette="CBR_wet"


       res0@cnMinLevelValF  = 10.
       res0@cnMaxLevelValF  = 90.
       res0@cnLevelSpacingF  = 10.

;       res1@cnFillPalette        = "sunshine_diff_12lev"
;       res1@cnFillPalette="precip3_16lev"
       res1@cnFillPalette="precip_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res1@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used
       res1@cnFillColors         = (/ 1,  2,   3,    4,  5,  6,  7,  8,  9,    10,  11/)  ; set the colors to be used


       res2=res1
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res2@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used
  end if

  if (isStrSubset("{$varModel}","shtfl")) then
       res0@cnMinLevelValF  = -40.
       res0@cnMaxLevelValF  = 120.
       res0@cnLevelSpacingF  = 20.

       res1@cnFillPalette        = "temp_diff_18lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -50., -30., -20.,-10.,-5., 5. ,10. ,20. ,30. , 50./)   ; set levels

       res2@cnFillPalette        = "temp_diff_18lev"
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
       
  if (isStrSubset("{$varModel}","2m")) then
      res0@cnMinLevelValF  = 220.
      res0@cnMaxLevelValF  = 310.
      res0@cnLevelSpacingF  = 10.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnFillPalette        = "BlueDarkRed18"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      ;res1@cnLevels             = (/ -5., -3., -2.,-1.,-0.5, 0.5 ,1. ,2. ,3. , 5./)   ; set levels
      res1@cnLevels             = (/ -10., -5., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 5., 10./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if 

  if (isStrSubset("{$varModel}","tmpsfc")) then
      res0@cnMinLevelValF  = 220.
      res0@cnMaxLevelValF  = 310.
      res0@cnLevelSpacingF  = 10.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnFillPalette        = "BlueDarkRed18"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -10., -5., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 5., 10./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","prate").or.isStrSubset("{$varModel}","lhtfl")) then
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.5,  1,   2, 4,   8, 16, 32  /)   ; set levels

      res1@cnFillPalette="precip_diff_12lev"
      res1@cnFillPalette="precip_diff_12lev"

      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/  -4, -2.,-1.,-0.5,-0.1, 0.1, 0.5 ,1. ,2., 4 /)   ; set levels

      res2@cnFillPalette="precip_diff_12lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","weasd")) then

      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 5., 10., 20., 40., 60., 80., 120., 160. /)   ; set levels

      res1@cnFillPalette="precip_diff_12lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/   -1.,-0.5, -0.2,-0.1,-0.05, 0.05, 0.1, 0.2, 0.5 ,1.  /)   ; set levels

      res2@cnFillPalette="precip_diff_12lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","snod")) then

      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.0001, 0.01, 0.1, 0.2, 0.3, 0.5,  1,  1.5 /)   ; set levels

      res1@cnFillPalette="precip_diff_12lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/   -1.,-0.5, -0.2,-0.1,-0.05, 0.05, 0.1, 0.2, 0.5 ,1.  /)   ; set levels

      res2@cnFillPalette="precip_diff_12lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","pwat")) then
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 1, 2, 4, 8, 16, 32, 64  /)   ; set levels

      res1@cnFillPalette="precip_diff_12lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/  -4, -2.,-1.,-0.5,-0.1, 0.1, 0.5 ,1. ,2., 4 /)   ; set levels

      res2@cnFillPalette="precip_diff_12lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","snow").or.isStrSubset("{$varModel}","noticec")) then
      res0@cnFillPalette="GMT_drywet"
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.5,  1, 5, 10, 20, 40, 60, 95/)   ; set levels

      res1@cnFillPalette="precip_diff_12lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -50., -25., -10., -5.,-1., 1.,5., 10., 25., 50. /)   ; set levels

      res2@cnFillPalette="precip_diff_12lev"
      res2@cnMinLevelValF  = -100.
      res2@cnMaxLevelValF  = 100.
      res2@cnLevelSpacingF  = 20.
  end if
  if (isStrSubset("{$varModel}","snow").or.isStrSubset("{$varModel}","icec")) then
       ;levs = (/0.05, 0.95, 0.1/)
       levs = (/0.5, 95., 10./)
       
       colormap = "amwg256"
       res0@cnFillPalette = colormap
       res0@cnLevelSelectionMode = "ManualLevels"     ; set the contour levels with the following 3 resources
       res0@cnMinLevelValF  = levs(0)                      ; set the minimum contour level
       res0@cnMaxLevelValF  = levs(1)                      ; set the maximum contour level
       res0@cnLevelSpacingF = levs(2)                      ; set the interval between contours

       res0@cnFillPalette="precip_diff_12lev"
       res0@cnFillPalette="prcp_1"
       res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res0@cnLevels             = (/ 1.e-15,  1, 5, 10, 20, 40, 60, 95/)   ; set levels

      res1@cnFillPalette="precip_diff_12lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -50., -25., -10., -5.,-1., 1.,5., 10., 25., 50. /)   ; set levels
   end if
       



  if (isStrSubset("{$varModel}","wrf")) then
       cmap=read_colormap_file("MPL_gnuplot")
       res0@cnFillPalette = cmap
       res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res0@cnLevels             = (/20., 40., 80., 100., 150., 200., 300., 400.,500. /)   ; set levels
       if (isStrSubset("{$varModel}","ulwrftoa")) then
           res0@cnLevels             = (/120., 140., 180., 200., 220., 240., 260., 280.,300. /)   ; set levels
       end if

       res1@cnFillPalette        = "sunshine_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels

       res2=res1
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if 
  ;res1@mpGeophysicalLineThicknessF=0.3
  res1@mpGeophysicalLineThicknessF=2.
  


  panelopts                   = True
  panelopts@gsnPanelMainString = "${varModel}, $season,  $truelength ICs, day $d1p1-$d2p1"
  panelopts@amJust   = "TopLeft"
  panelopts@gsnOrientation    = "landscape"
  panelopts@gsnPanelLabelBar  = False
  panelopts@gsnPanelRowSpec   = True
  panelopts@gsnMaximize       = True                          ; maximize plot in frame
  panelopts@gsnBoxMargin      = 0
  panelopts@gsnPanelYWhiteSpacePercent = 0
  panelopts@gsnPanelXWhiteSpacePercent = 5
  panelopts@amJust   = "TopLeft"

  if ($nplots.eq.1) then
   plot(0) = gsn_csm_contour_map_polar(wks,${nameModelBA}_diff,res1)
   gsn_panel(wks,plot,(/1/),panelopts)
  end if
  if ($nplots.eq.3) then
   plot(0) = gsn_csm_contour_map_polar(wks,${nameModelA}_mean,res0)
   plot(1) = gsn_csm_contour_map_polar(wks,${nameModelB}_mean,res0)
   plot(2) = gsn_csm_contour_map_polar(wks,${nameModelBA}_diff,res1)
   gsn_panel(wks,plot,(/2,1/),panelopts)
  end if

EOF

ncl -Q map_${season}.polar.ncl



