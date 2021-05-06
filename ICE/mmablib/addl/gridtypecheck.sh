#Check the lat-long grids:
for type in AKW_wave ENP_wave WNA_wave laurentia nomura levitus_atlas rotllgrid mrf1deg gfs_quarter global_nesdis_half global_wave great_lakes_wave nh_ocean_weather nh_hazard global_hazard global_nth global_quarter global_eighth global_12th global_15th global_20th ostia global_ice global_sst stlawrence okhotsk walcc
do
  g++ -Wall -O2 -DLINUX -DGRIDTYPE=$type gridtypecheck.C -o $type ../libombf_4.a
  ./$type > $type.out
done

#Check polar stereographic grids:
for type in northmodel southmodel north_nesdis_eighth great_lakes_10km great_lakes_1km northgrid southgrid ramp_high ramp_low nsidcnorth nsidcsouth bedient_north ims_north
do
  g++ -Wall -O2 -DLINUX -DGRIDTYPE=$type gridtypecheck.C -o $type ../libombf_4.a
  ./$type > $type.out
done

