\name{mongo.aggregation}
\alias{mongo.aggregation}
\title{Aggregation pipeline}
\usage{
mongo.aggregation(mongo, ns, aggr_cmd_list)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find distinct keys.}

  \item{aggr_cmd_list}{\link{mongo.bson} An list
  representing aggregation query pipeline.}
}
\value{
NULL if the command failed.  \code{\link{mongo.get.err}()}
may be MONGO_COMMAND_FAILED.

\link{mongo.bson} The result of aggregation.
}
\description{
Aggregation pipeline
}
\details{
See
\url{http://docs.mongodb.org/manual/core/aggregation-pipeline/}.
}
\examples{
# using the zips example data set
mongo <- mongo.create()
# insert some example data
data(zips)
colnames(zips)[5] <- "orig_id"
ziplist <- list()
ziplist <- apply( zips, 1, function(x) c( ziplist, x ) )
res <- lapply( ziplist, function(x) mongo.bson.from.list(x) )
if (mongo.is.connected(mongo)) {
    mongo.insert.batch(mongo, "test.zips", res )
    pipe_1 <- mongo.bson.from.JSON('{"$group":{"_id":"$state", "totalPop":{"$sum":"$pop"}}}')
    cmd_list <- list(pipe_1)
    res <- mongo.aggregation(mongo, "test.zips", cmd_list)
}
mongo.destroy(mongo)
}
\seealso{
\code{\link{mongo.command}},\cr
\code{\link{mongo.simple.command}},\cr
\code{\link{mongo.find}},\cr \link{mongo}.
}

