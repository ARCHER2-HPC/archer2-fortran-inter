
#include <stdio.h>

void c_array(int mlen, int nlen, int idata[][mlen]) {

  for (int n = 0; n < nlen; n++) {
    for (int m = 0; m < mlen; m++) {
      printf("Element [%1d][%1d] %2d %2d\n", n, m, n*mlen + m, idata[n][m]);
    }
  }
  return;
}

