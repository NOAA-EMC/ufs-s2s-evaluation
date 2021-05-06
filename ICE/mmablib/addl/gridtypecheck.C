#include "llgrid.h"
#include "ncepgrids.h"
#include "legacy.h"

int main(void) {
  GRIDTYPE<float>  x;
  //okhotsk<float>  y;
  ijpt ll, ur;
  latpt l1, l2;

  ll.i = 0; ll.j = 0;
  ur.i = x.xpoints() - 1;
  ur.j = x.ypoints() - 1;
  l1 = x.locate(ll);
  l2 = x.locate(ur);
  printf("corner locs are %f %f  %f %f\n",l1.lon, l1.lat, l2.lon, l2.lat);


//  ur.i = y.xpoints() - 1;
//  ur.j = y.ypoints() - 1;
//  l1 = y.locate(ll);
//  l2 = y.locate(ur);
//  printf("corner locs okhotsk are %f %f  %f %f\n",l1.lon, l1.lat, l2.lon, l2.lat);

  return 0;
}
