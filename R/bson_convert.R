#' Convert JSON to BSON Object 
#' 
#' Converts a JSON string to a mongo BSON object.
#' 
#' @param JSON (string) A valid JSON string.
#' @param simplifyVector (FALSE) coerse JSON arrays containing only scalars into a vector.
#' @param ... additional parameters parsed to fromJSON
#' 
#' @return A BSON object.
#' 
#' @seealso \code{\link{mongo.find}},\cr \code{\link{mongo.bson.from.list}}, \cr \code{\link{mongo.bson}}
#' , \cr \code{\link{fromJSON}}.
#' 
#' @examples
#' mongo.bson.from.JSON('{"name" : "Peter"}')
#' mongo.bson.from.JSON('{"_id" : 1}')
#' 
#' 
#' @export mongo.bson.from.JSON
mongo.bson.from.JSON <- function(JSON, simplifyVector=FALSE, ...){
  
  if( !validate(I(JSON)) ){
    stop("Not a valid JSON content: ", JSON)
  }
  
  json_list <- fromJSON(JSON, simplifyVector=simplifyVector, ...)
  
  if( length(json_list) == 0 ){
    bson <- mongo.bson.empty()
  } else
    bson <- mongo.bson.from.list( as.list( json_list  ) )
  
  return(bson)
}





#' Convert a mongo.bson object to an R object.
#' 
#' Convert a \link{mongo.bson} object to an R object.
#' 
#' Note that this function and \code{\link{mongo.bson.from.list}()} do not
#' always perform inverse conversions since \code{mongo.bson.to.list}() will
#' convert objects and subobjects to atomic vectors if possible.
#' 
#' This function is somewhat schizophrenic depending on the types of the fields
#' in the mongo.bson object. If all fields in an object (or subobject/array)
#' can be converted to the same atomic R type (for example they are all strings
#' or all integer, you'll actually get out a vector of the atomic type with the
#' names attribute set.
#' 
#' For example, if you construct a mongo.bson object like such:
#' 
#' \preformatted{buf <- mongo.bson.buffer.create()
#' mongo.bson.buffer.append(buf, "First", "Joe") mongo.bson.buffer.append(buf,
#' "Last", "Smith") b <- mongo.bson.from.buffer(buf) l <-
#' mongo.bson.to.list(b)}
#' 
#' You'll get a vector of strings out of it which may be indexed by number,
#' like so:
#' 
#' \code{print(l[1]) # display "Joe"}
#' 
#' or by name, like so:
#' 
#' \code{print(l[["Last"]]) # display "Smith"}
#' 
#' If, however, the mongo.bson object is made up of disparate types like such:
#' 
#' \preformatted{buf <- mongo.bson.buffer.create()
#' mongo.bson.buffer.append(buf, "Name", "Joe Smith")
#' mongo.bson.buffer.append(buf, "age", 21.5) b <- mongo.bson.from.buffer(buf)
#' l <- mongo.bson.to.list(b)}
#' 
#' You'll get a true list (with the names attribute set) which may be indexed
#' by number also:
#' 
#' \code{print(l[1]) # display "Joe Smith"}
#' 
#' or by name, in the same fashion as above, like so
#' 
#' \code{print(l[["Name"]]) # display "Joe Smith"}
#' 
#' \strong{but} also with the $ operator, like so:
#' 
#' \code{print(l$age) # display 21.5}
#' 
#' Note that \code{mongo.bson.to.list()} operates recursively on subobjects and
#' arrays and you'll get lists whose members are lists or vectors themselves.
#' See \code{\link{mongo.bson.value}()} for more information on the conversion
#' of component types.
#' 
#' This function also detects the special wrapper as output by
#' \code{\link{mongo.bson.buffer.append.object}()} and will return an
#' appropriately attributed object.
#' 
#' Perhaps the best way to see what you are going to get for your particular
#' application is to test it.
#' 
#' 
#' @param b (\link{mongo.bson}) The mongo.bson object to convert.
#' @return Best guess at an appropriate R object representing the mongo.bson
#' object.
#' @seealso \code{\link{mongo.bson.from.list}},\cr \link{mongo.bson}.
#' @examples
#' 
#' buf <- mongo.bson.buffer.create()
#' mongo.bson.buffer.append(buf, "name", "Fred")
#' mongo.bson.buffer.append(buf, "city", "Dayton")
#' b <- mongo.bson.from.buffer(buf)
#' 
#' l <- mongo.bson.to.list(b)
#' print(l)
#' 
#' @export mongo.bson.to.list
mongo.bson.to.list <- function(b)
  .Call(".mongo.bson.to.list", b)




#' Convert a list to a mongo.bson object
#' 
#' Convert a list to a \link{mongo.bson} object.
#' 
#' This function permits the simple and convenient creation of a mongo.bson
#' object.  This bypasses the creation of a \link{mongo.bson.buffer}, appending
#' fields one by one, and then turning the buffer into a mongo.bson object with
#' \code{\link{mongo.bson.from.buffer}()}.
#' 
#' Note that this function and \code{\link{mongo.bson.to.list}()} do not always
#' perform inverse conversions since mongo.bson.to.list() will convert objects
#' and subobjects to atomic vectors if possible.
#' 
#' 
#' @param lst (list) The list to convert.
#' 
#' This \emph{must} be a list, \emph{not} a vector of atomic types; otherwise,
#' an error is thrown; use \code{as.list()} as necessary.
#' @return (\link{mongo.bson}) A mongo.bson object serialized from \code{lst}.
#' @seealso \code{\link{mongo.bson.to.list}},\cr \link{mongo.bson},\cr
#' \code{\link{mongo.bson.destroy}}.
#' @examples
#' 
#' lst <- list(name="John", age=32)
#' b <- mongo.bson.from.list(lst)
#' # the above produces a BSON object of the form:
#' # { "name" : "John", "age" : 32.0 }
#' 
#' # Convert a vector of an atomic type to a list and
#' # then to a mongo.bson object
#' v <- c(president="Jefferson", vice="Burr")
#' b <- mongo.bson.from.list(as.list(v))
#' # the above produces a BSON object of the form:
#' # { "president" : "Jefferson", "vice" : "Burr" }
#' 
#' @export mongo.bson.from.list
mongo.bson.from.list <- function(lst)
  .Call(".mongo.bson.from.list", lst)

