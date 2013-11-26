\name{print.mongo.bson}
\alias{print.mongo.bson}
\title{Display a mongo.bson object}
\usage{
  \method{print}{mongo.bson} (x, ...)
}
\arguments{
  \item{x}{(\link{mongo.bson} The object to display.}

  \item{...}{Parameters passed from generic.}
}
\value{
  The parameter is returned unchanged.
}
\description{
  Display formatted output of a mongo.bson object.
}
\details{
  Output is tabbed (indented to show the nesting level of
  subobjects and arrays).

  This version is an alias of mongo.bson.print() so that
  print() will properly handle the mongo.bson class.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
b <- mongo.bson.from.buffer(buf)

# all display the same thing
print.mongo.bson(b)
mongo.bson.print(b)
print(b)
}
\seealso{
  \code{\link{mongo.bson.print}},\cr \link{mongo.bson}.
}

