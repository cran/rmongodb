#' Get a vector of distinct values for keys in a collection
#' 
#' Get a vector of distinct values for keys in a collection.
#' 
#' See
#' \url{http://www.mongodb.org/display/DOCS/Aggregation#Aggregation-Distinct}.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find distinct
#' keys.
#' @param key (string) The name of the key field for which to get distinct
#' values.
#' @param query \link{mongo.bson} An optional query to restrict the returned
#' values.
#' 
#' @return NULL if the command failed.  \code{\link{mongo.get.err}()} may be
#' MONGO_COMMAND_FAILED.
#' 
#' (vector) The result set of distinct keys.
#' @seealso \code{\link{mongo.command}},\cr
#' \code{\link{mongo.simple.command}},\cr \code{\link{mongo.find}},\cr
#' \link{mongo}.
#' 
#' @examples
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     keys <- mongo.distinct(mongo, "test.people", "name")
#'     print(keys)
#' }
#' 
#' @aliases mongo.get.values
#' @export mongo.get.values
#' @export mongo.distinct
mongo.distinct <- function(mongo, ns, key, query=mongo.bson.empty()) {
  
  pos <- regexpr('\\.', ns)
  if (pos == 0) {
    print("mongo.distinct: No '.' in namespace")
    return(NULL)
  }
  db <- substr(ns, 1, pos-1)
  collection <- substr(ns, pos+1, nchar(ns))
  b <- mongo.command(mongo, db, list(distinct=collection, key=key, query=query))
  if (!is.null(b))
    b <- mongo.bson.value(b, "values")
  b
}
mongo.get.values <- mongo.distinct
