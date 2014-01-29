#' @useDynLib rmongodb
#' @import jsonlite
#'
.onUnload <- function(libpath)
    library.dynam.unload("rmongodb", libpath)


