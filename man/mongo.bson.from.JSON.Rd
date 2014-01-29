\name{mongo.bson.from.JSON}
\alias{mongo.bson.from.JSON}
\title{Convert JSON to BSON Object}
\usage{
mongo.bson.from.JSON(JSON, simplifyVector = FALSE, ...)
}
\arguments{
  \item{JSON}{(string) A valid JSON string.}

  \item{simplifyVector}{(FALSE) coerse JSON arrays
  containing only scalars into a vector.}

  \item{...}{additional parameters parsed to fromJSON}
}
\value{
A BSON object.
}
\description{
Converts a JSON string to a mongo BSON object.
}
\examples{
mongo.bson.from.JSON('{"name" : "Peter"}')
mongo.bson.from.JSON('{"_id" : 1}')
}
\seealso{
\code{\link{mongo.find}},\cr
\code{\link{mongo.bson.from.list}}, \cr
\code{\link{mongo.bson}} , \cr \code{\link{fromJSON}}.
}

