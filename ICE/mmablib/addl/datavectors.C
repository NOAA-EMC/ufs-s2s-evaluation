#include "datavectors.h"

int main(void) {
  otislev<float> otis;
  otistag<int> otist;
  levitus_depths<float> levitus;
  nodc_depths<float> nodc;

  printf("%f\n",otis[5]);
  printf("%d\n",otist[5]);
  printf("%f\n",levitus[5]);
  printf("%f\n",nodc[5]);

  return 0;
}
