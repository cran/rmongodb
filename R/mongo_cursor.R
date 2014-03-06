#' Convert Mongo Cursor Object to List 
#' 
#' Converts a mongo cursor object to a list by interating over all cursor objects and combining them.
#' 
#' @param cursor (\link{mongo.cursor}) A mongo.cursor object returned from
#' \code{\link{mongo.find}()}.
#' @param nullToNA (boolean) If \code{NULL} values will be torned into \code{NA} values. 
#' Usually this is a good idea, because sporadic \code{NULL} values will cause structural 
#' problems in the data.frame, whereas \code{NA} values will just appear as regular \code{NA}s.

#' @return An R list object.
#' 
#' @seealso \code{\link{mongo.find}},\cr \code{\link{mongo.bson.to.list}}.
#' 
#' @examples
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "age", 22L)
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     # Find the first 100 records
#'     #    in collection people of database test where age == 22
#'     cursor <- mongo.find(mongo, "test.people", query, limit=100L)
#' 
#'     res <- mongo.cursor.to.list(cursor)
#' 
#' }
#' 
#' @export mongo.cursor.to.list
mongo.cursor.to.list <- function(cursor, nullToNA = TRUE){
  
  warning("This fails for most NoSQL data structures. I am working on a new solution")
  
  res <- list()
  while ( mongo.cursor.next(cursor) ){
    val <- mongo.bson.to.list(mongo.cursor.value(cursor))
    
    if( nullToNA == TRUE )
      val[sapply(val, is.null)] <- NA
    
    res <- rbind(res, val)
    
  }
  
  return(res)
}



#' Convert Mongo Cursor Object to Data.Frame 
#' 
#' Converts a mongo cursor object to a data.frame by interating over all cursor objects and combining them.
#' 
#' Note that mongo.oid columns will be removed. data.frame can not deal with them.
#' 
#' @param cursor (\link{mongo.cursor}) A mongo.cursor object returned from
#' \code{\link{mongo.find}()}.
#' @param ... Additional parameters parsed to the function \code{\link{as.data.frame}}
#' @param nullToNA (boolean) If \code{NULL} values will be torned into \code{NA} values. 
#' Usually this is a good idea, because sporadic \code{NULL} values will cause structural 
#' problems in the data.frame, whereas \code{NA} values will just appear as regular \code{NA}s.
#' 
#' @return An R data.frame object.
#' 
#' @seealso \code{\link{mongo.find}},\cr \code{\link{as.data.frame}}.
#' 
#' @examples
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "age", 22L)
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     # Find the first 100 records
#'     #    in collection people of database test where age == 22
#'     cursor <- mongo.find(mongo, "test.people", query, limit=100L)
#' 
#'    res <- mongo.cursor.to.data.frame(cursor)
#' 
#' }
#' 
#' @export mongo.cursor.to.data.frame
mongo.cursor.to.data.frame <- function(cursor, nullToNA=TRUE, ...){
  
  warning("This fails for most NoSQL data structures. I am working on a new solution")
  
  res <- data.frame()
  while ( mongo.cursor.next(cursor) ){
    val <- mongo.bson.to.list(mongo.cursor.value(cursor))
    
    if( nullToNA == TRUE )
      val[sapply(val, is.null)] <- NA
    
    # remove mongo.oid -> data.frame can not deal with that!
    val <- val[sapply(val, class) != 'mongo.oid']
       
    res <- rbind.fill(res, as.data.frame(val, ... ))
    
  }
  return( as.data.frame(res) )
}



# rbind.nosql <- function (...) 
# {
#   # based on rbind.fill idea of plyr
#   dfs <- list(...)
#   if (length(dfs) == 0) 
#     return()
#   if (is.list(dfs[[1]]) && !is.data.frame(dfs[[1]])) {
#     dfs <- dfs[[1]]
#   }
#   if (length(dfs) == 0) 
#     return()
#   if (length(dfs) == 1) 
#     return(dfs[[1]])
#   #is_df <- vapply(dfs, is.data.frame, logical(1))
#   #if (any(!is_df)) {
#   #  stop("All inputs to rbind.fill must be data.frames", 
#   #       call. = FALSE)
#   #}
#   rows <- unlist(lapply(dfs, .row_names_info, 2L))
#   nrows <- sum(rows)
#   output <- output_template(dfs, nrows)
#   if (length(output) == 0) {
#     return(as.data.frame(matrix(nrow = nrows, ncol = 0)))
#   }
#   pos <- matrix(c(cumsum(rows) - rows + 1, rows), ncol = 2)
#   for (i in seq_along(rows)) {
#     rng <- seq(pos[i, 1], length = pos[i, 2])
#     df <- dfs[[i]]
#     for (var in names(df)) {
#       if (!is.matrix(output[[var]])) {
#         if (is.factor(output[[var]]) && is.character(df[[var]])) {
#           output[[var]] <- as.character(output[[var]])
#         }
#         output[[var]][rng] <- df[[var]]
#       }
#       else {
#         output[[var]][rng, ] <- df[[var]]
#       }
#     }
#   }
#   quickdf(output)
# }



#' Advance a cursor to the next record
#' 
#' \code{\link{mongo.cursor.next}(cursor)} is used to step to the first or next
#' record.
#' 
#' \code{\link{mongo.cursor.value}(cursor)} may then be used to examine it.
#' 
#' 
#' @param cursor (\link{mongo.cursor}) A mongo.cursor object returned from
#' \code{\link{mongo.find}()}.
#' @return TRUE if there is a next record; otherwise, FALSE.
#' @seealso \code{\link{mongo.find}},\cr \link{mongo.cursor},\cr
#' \code{\link{mongo.cursor.value}},\cr \code{\link{mongo.cursor.destroy}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "city", "St. Louis")
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     # Find the first 1000 records in collection people
#'     # of database test where city == "St. Louis"
#'     cursor <- mongo.find(mongo, "test.people", query, limit=1000L)
#'     # Step though the matching records and display them
#'     while (mongo.cursor.next(cursor))
#'         print(mongo.cursor.value(cursor))
#'     mongo.cursor.destroy(cursor)
#' }
#' 
#' @export mongo.cursor.next
mongo.cursor.next <- function(cursor)
  .Call(".mongo.cursor.next", cursor)



#' Fetch the current value of a cursor
#' 
#' \code{\link{mongo.cursor.value}(cursor)} is used to fetch the current record
#' belonging to a\cr \code{\link{mongo.find}()} query.
#' 
#' 
#' @param cursor (\link{mongo.cursor}) A mongo.cursor object returned from
#' \code{\link{mongo.find}()}.
#' @return (\link{mongo.bson}) The current record of the result set.
#' @seealso \code{\link{mongo.find}},\cr \code{\link{mongo.cursor}},\cr
#' \code{\link{mongo.cursor.next}},\cr \code{\link{mongo.cursor.value}},\cr
#' \code{\link{mongo.cursor.destroy}},\cr \link{mongo.bson}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "city", "St. Louis")
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     # Find the first 1000 records in collection people
#'     # of database test where city == "St. Louis"
#'     cursor <- mongo.find(mongo, "test.people", query, limit=1000L)
#'     # Step though the matching records and display them
#'     while (mongo.cursor.next(cursor))
#'         print(mongo.cursor.value(cursor))
#'     mongo.cursor.destroy(cursor)
#' }
#' 
#' @export mongo.cursor.value
mongo.cursor.value <- function(cursor)
  .Call(".mongo.cursor.value", cursor)



#' Release resources attached to a cursor
#' 
#' \code{mongo.cursor.destroy(cursor)} is used to release resources attached to
#' a cursor on both the client and server.
#' 
#' Note that \code{mongo.cursor.destroy(cursor)} may be called before all
#' records of a result set are iterated through (for example, if a desired
#' record is located in the result set).
#' 
#' Although the 'destroy' functions in this package are called automatically by
#' garbage collection, this one in particular should be called as soon as
#' feasible when finished with the cursor so that server resources are freed.
#' 
#' 
#' @param cursor (\link{mongo.cursor}) A mongo.cursor object returned from
#' \code{\link{mongo.find}()}.
#' @return TRUE if successful; otherwise, FALSE (when an error occurs during
#' sending the Kill Cursor operation to the server). in either case, the cursor
#' should not be used for further operations.
#' @seealso \code{\link{mongo.find}},\cr \link{mongo.cursor},\cr
#' \code{\link{mongo.cursor.next}},\cr \code{\link{mongo.cursor.value}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "city", "St. Louis")
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     # Find the first 1000 records in collection people
#'     # of database test where city == "St. Louis"
#'     cursor <- mongo.find(mongo, "test.people", query, limit=1000L)
#'     # Step though the matching records and display them
#'     while (mongo.cursor.next(cursor))
#'         print(mongo.cursor.destroy(cursor))
#'     mongo.cursor.destroy(cursor)
#' }
#' 
#' @export mongo.cursor.destroy
mongo.cursor.destroy <- function(cursor)
  .Call(".mongo.cursor.destroy", cursor)


