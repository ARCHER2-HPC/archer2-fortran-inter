
#include <stdio.h>

int c_snprintf_float(char * str, size_t size, const char * format, float x) {

  return snprintf(str, size, format, x);
}

int c_snprintf_double(char * str, size_t size, const char * format, double x) {

  return snprintf(str, size, format, x);
}
