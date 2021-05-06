#include "resops.h"

int main(void) {
  resops<float> x, y;
  float f1, f2, f3, f4;
  ijpt loc;
  fijpt floc, floc2;
  latpt ll;

  x.locate(loc);
  x.locate(floc);
  x.locate(ll);

  x.subset(y, f1, f2, f3, f4);

  x.iscyclicx();
  x.firstlon();

// hycom (atl)
  hycom<float> h1, ddx, ddy;
  FILE *fouta, *foutb;
  char message[90];
  float mask;

  h1.outa(fouta);
  h1.outb(foutb);
  h1.outb(foutb, message);
  h1.ina(fouta);
  h1.inb(foutb);

  h1.div(ddx, ddy);
  h1.advect(floc, floc2);  
  h1.accurate(floc2);

// readin:
  grid2<float> g1, g2;
  readin<float> r1, r2(g1, g2), rddx, rddy;

  r1.grad(rddx, rddy, mask);
  r1.div(rddx, rddy);
  

  return 0;
}
