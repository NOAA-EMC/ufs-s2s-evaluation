#include "grid3.h"

int main(void) {
  grid3<float> x1;
  grid3<float> x2(30);
  grid3<float> x3(5,6,7);
  mvector<float> z;
  grid2<float> layer;
  ijpt loc, loc2;
  int i;
  FILE *fout;

  x3.zpoints();
  x3[loc];
  x3[i];

  x3.set((float) 0.5);
  x3.binout(fout);
  rewind(fout);
  x3.binin(fout);
  x3.printer(stdout);

  x3.get_sounding(loc);
  x3.get_sounding(loc, z);
  x3.put_sounding(loc, z);
 
  layer = x3.get_layer(5);
  x3.get_layer(5, layer);
  x3.put_layer(5, layer);

  x3.get_transect(loc, loc2, layer);
  x2 = x3;
  x3 += x2;
  x3 -= x2;
  x3 /= 4;
  x3 *= 4;

  return 0;
}
