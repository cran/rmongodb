/* Dmitriy Selivanov (2014) https://github.com/dselivanov */
#include <R.h>
#include "helpers.h"

// check for NA values.
// returns vector of flags whether element is NA
// this function is from "Advanced R" (http://adv-r.had.co.nz/C-interface.html) by Hadley Wickham.
int* _IS_NA(SEXP x) {
  int n = length(x);
  int* is_na = malloc(n * sizeof(int));
  for (int i = 0; i < n; i++) {
    switch(TYPEOF(x)) {
      case LGLSXP:
        is_na[i] = (LOGICAL(x)[i] == NA_LOGICAL);
      break;
      case INTSXP:
        is_na[i] = (INTEGER(x)[i] == NA_INTEGER);
      break;
      case REALSXP:
        is_na[i] = ISNA(REAL(x)[i]) || ISNAN(REAL(x)[i]);
      break;
      case STRSXP:
        is_na[i] = (STRING_ELT(x, i) == NA_STRING);
      break;
      default:
        is_na[i] = 0;
    }
  }
  return is_na;
}
