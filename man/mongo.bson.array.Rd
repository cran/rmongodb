\docType{data}
\name{mongo.bson.array}
\alias{mongo.bson.array}
\title{BSON data type constant for an array}
\format{\preformatted{ int 4
}}
\usage{
mongo.bson.array
}
\value{
4L
}
\description{
\code{\link{mongo.bson.iterator.type}()} and
\code{\link{mongo.bson.iterator.next}()} will return this
constant (4L) to indicate that the value pointer to by an
iterator is an array (containing child values).
}
\seealso{
\code{\link{mongo.bson.iterator.type}},\cr
\code{\link{mongo.bson.iterator.next}},\cr
\link{mongo.bson.iterator},\cr \link{mongo.bson}.
}
\keyword{datasets}

