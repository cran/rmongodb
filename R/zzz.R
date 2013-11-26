#' @useDynLib rmongodb
#'
.onUnload <- function(libpath)
    library.dynam.unload("rmongodb", libpath)


