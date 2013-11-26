\docType{data}
\name{mongo.bson.dbref}
\alias{mongo.bson.dbref}
\title{BSON data type constant for a dbref value}
\format{int 12}
\usage{
  mongo.bson.dbref
}
\value{
  12L
}
\description{
  \code{\link{mongo.bson.iterator.type}()} and
  \code{\link{mongo.bson.iterator.next}()} will return this
  constant (12L) to indicate that the value pointed to by
  an iterator is a dbref (database reference).
}
\details{
  Note that this BSON data type is deprecated and rmongodb
  provides no support for it. Attempting to fetch the value
  of a dbref with \code{\link{mongo.bson.to.list}()} or\cr
  \code{\link{mongo.bson.iterator.value}()} will throw an
  error. The field must be skipped by calling
  \code{\link{mongo.bson.iterator.next}()}.
}
\seealso{
  \code{\link{mongo.bson.iterator.type}},\cr
  \code{\link{mongo.bson.iterator.next}},\cr
  \link{mongo.bson}.
}
\keyword{datasets}

