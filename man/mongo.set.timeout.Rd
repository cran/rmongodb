\name{mongo.set.timeout}
\alias{mongo.set.timeout}
\title{Set the timeout value on a mongo connection}
\usage{
  mongo.set.timeout(mongo, timeout)
}
\arguments{
  \item{mongo}{(\link{mongo}) a mongo connection object.}

  \item{timeout}{(as.integer) number of milliseconds to
  which to set the timeout value.}
}
\description{
  Set the timeout value for network operations on a mongo
  connection. Subsequent network operations will timeout if
  they take longer than the given number of milliseconds.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    mongo.set.timeout(mongo, 2000L)
    timeout <- mongo.get.timeout(mongo)
    if (timeout != 2000L)
        error("expected timeout of 2000");
}
}
\seealso{
  \code{\link{mongo.get.timeout}},\cr
  \code{\link{mongo.create}},\cr \link{mongo}.
}

