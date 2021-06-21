#LINUX
CC=g++
OPTS=-O2 -DLINUX -Wall  -I/usr1/rmg3/svn/mmablib/include -DVEC_LENGTH=1024 -DVERBOSE -DVERBOSE2
#OPTS=-O2 -DLINUX -Wall  -I/usr1/rmg3/svn/mmablib/include -DVEC_LENGTH=1024 -DVERBOSE -DVERBOSE2
LIBS=~/usrlocal/lib/libombf_4.a

#--------------------------------------
all : backnametest basetest buoy buoytest cofs color colortest datavectors eta flip gaussian genes genetest grib gribtest grid3 grid_base grid_math lambert legacy llgrid mercator mvector nametest ncepgrids params points psgrid resops ssmi ssmis time_series

.C :
	$(CC) -c $(OPTS) $(@).C
	$(CC) $(OPTS) $(@).o -o $(@) $(LIBS)
	./$(@)
	
.o :
	$(CC) $(OPTS) $(@).o -o $(@) $(LIBS)
	./$(@)

clean :
	rm *.o backnametest basetest buoy buoytest cofs color colortest datavectors eta flip gaussian genes genetest grib gribtest grid3 grid_base grid_math lambert legacy llgrid mercator mvector nametest ncepgrids params points psgrid resops ssmi ssmis time_series
