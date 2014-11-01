/* Reduced code to convert BSON to R list without any type conversion maddness. Jeroen Ooms (2014) - https://github.com/jeroenooms */
/* Added code for simplifying arrays. Dmitriy Selivanov (2014) https://github.com/dselivanov */
#include <R.h>
#include "api_bson.h"
#include "utility.h"
#include <stdbool.h>

typedef bson bson_buffer;

SEXP ConvertValue(bson_iterator* iter, bool simplify);
SEXP ConvertObject(bson* b, bool is_namedlist, bool simplify);
SEXP R_ConvertObject(SEXP x, SEXP simplify);
SEXP ConvertArray(bson* b, bool simplify);

SEXP R_ConvertObject(SEXP x, SEXP simplify) {
  bson* b = _checkBSON(x);
  return ConvertObject(b, true, (asLogical(simplify) == 1));
}


SEXP ConvertValue(bson_iterator* iter, bool simplify){
    bson sub;
    SEXP ret;
    bson_type sub_type = bson_iterator_type(iter);
    switch (sub_type) {
        case BSON_INT:
            return ScalarInteger(bson_iterator_int(iter));
        case BSON_DOUBLE:
            return ScalarReal(bson_iterator_double(iter));
        case BSON_STRING:
            return mkString(bson_iterator_string(iter));
        case BSON_BOOL:
            return ScalarLogical(bson_iterator_bool(iter));
        case BSON_LONG:
            return ScalarReal(bson_iterator_long(iter));
        case BSON_DATE:
            PROTECT(ret = ScalarReal(bson_iterator_date(iter) / 1000));
            SEXP cls;
            PROTECT(cls = allocVector(STRSXP, 2));
            SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
            SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
            classgets(ret, cls);
            UNPROTECT(2);
            return ret;
        case BSON_ARRAY:
            bson_iterator_subobject(iter, &sub);
            if(simplify) return ConvertArray(&sub, simplify);
            else return(ConvertObject(&sub, false, simplify));
        case BSON_OBJECT:
            bson_iterator_subobject(iter, &sub);
            return ConvertObject(&sub, true, simplify);
        case BSON_BINDATA:
        case BSON_OID:
        case BSON_NULL:
        case BSON_TIMESTAMP:
        case BSON_REGEX:
        case BSON_UNDEFINED:
        case BSON_SYMBOL:
        case BSON_CODEWSCOPE:
        case BSON_CODE:
          return _mongo_bson_value(iter);
        default:
            error("Unhandled BSON type %d\n", sub_type);
    }
}

SEXP ConvertObject(bson* b, bool is_namedlist, bool simplify) {
    SEXP names, ret;
    bson_iterator iter;
    bson_type sub_type;

    //iterate over array to get size
    int count = 0;
    bson_iterator_init(&iter, b);
    while(bson_iterator_next(&iter)){
      count++;
    }

    //reset iterator
    bson_iterator_init(&iter, b);
    PROTECT(ret = allocVector(VECSXP, count));
    PROTECT(names = allocVector(STRSXP, count));
    for (int i = 0; (sub_type = bson_iterator_next(&iter)); i++) {
        SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
        SET_VECTOR_ELT(ret, i, ConvertValue(&iter, simplify));
    }
    //only add names for BSON object
    if(is_namedlist) {
      setAttrib(ret, R_NamesSymbol, names);
    }
    UNPROTECT(2);
    return ret;
}

SEXP ConvertArray(bson* b, bool simplify) {
    SEXP ret;
    bson_iterator iter;
    bson_type sub_type;
    bson_type previous_element_sub_type = BSON_EOO;
    bson_type array_type = BSON_EOO;
    int count = 0;
    bson_iterator_init(&iter, b);
    // iterate over array to get size
    // First,  we assume array is plain vanilla.
    // If it will array of complex elements, we will change FLAG_plain_vanilla_array
    bool FLAG_plain_vanilla_array = simplify;
    bson_iterator_init(&iter, b);
    while((sub_type = bson_iterator_next(&iter))) {
      count++;
      if(FLAG_plain_vanilla_array) {
        // array can contain only simple data types
        switch (sub_type) {
          case BSON_INT: ;
          case BSON_DOUBLE: ;
          case BSON_LONG: ;
          case BSON_STRING: ;
          case BSON_BOOL: ;
          case BSON_DATE:
          // try to determine type of array. Set it to current element type;
            array_type = sub_type;
            break;
          default:
          // if type of any element is not simple primitive, we will **create list** instead of array;
            FLAG_plain_vanilla_array = false;
        }
        // Also we will **create list** instead of array if values in array are have simple, BUT diffrent types
        if((previous_element_sub_type != sub_type) && (count > 1)) {
          FLAG_plain_vanilla_array = false;
        }
        // store previous element type;
        previous_element_sub_type = sub_type;
      }
    }
    //reset iterator
    bson_iterator_init(&iter, b);
    int i = 0;
    // for array of complex objects create list
    if(!FLAG_plain_vanilla_array) {
      PROTECT(ret = allocVector(VECSXP, count));
      while(bson_iterator_next(&iter)) {
          SET_VECTOR_ELT(ret, i++, ConvertValue(&iter, simplify));
      }
    }
    // for primitive types construct plain array
    else {
      switch (array_type) {
        case BSON_INT:
          PROTECT(ret = allocVector(INTSXP, count));
          while(bson_iterator_next(&iter)) {
              INTEGER(ret)[i++] = bson_iterator_int(&iter);
          }
          break;
        case BSON_LONG:
          PROTECT(ret = allocVector(REALSXP, count));
          while(bson_iterator_next(&iter)) {
              REAL(ret)[i++] = bson_iterator_long(&iter);
          }
          break;
        case BSON_DOUBLE:
          PROTECT(ret = allocVector(REALSXP, count));
          while(bson_iterator_next(&iter)) {
              REAL(ret)[i++] = bson_iterator_double(&iter);
          }
          break;
        case BSON_STRING:
          PROTECT(ret = allocVector(STRSXP, count));
          while(bson_iterator_next(&iter)) {
              SET_STRING_ELT(ret, i++, mkChar(bson_iterator_string(&iter)));
          }
          break;
        case BSON_BOOL:
          PROTECT(ret = allocVector(LGLSXP, count));
          while(bson_iterator_next(&iter)) {
              LOGICAL(ret)[i++] = bson_iterator_bool(&iter);
          }
          break;
        case BSON_DATE:
          PROTECT(ret = allocVector(REALSXP, count));
          while(bson_iterator_next(&iter)) {
              REAL(ret)[i++] = bson_iterator_date(&iter) / 1000;
          }
          SEXP cls;
          PROTECT(cls = allocVector(STRSXP, 2));
          SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
          SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
          classgets(ret, cls);
          UNPROTECT(1);
          break;
        /*should never reaches here */
        default:
          PROTECT(ret = allocVector(VECSXP, count));
          while(bson_iterator_next(&iter))
              SET_VECTOR_ELT(ret, i++, ConvertValue(&iter, simplify));
          break;
      }
    }
    UNPROTECT(1);
    return ret;
}
