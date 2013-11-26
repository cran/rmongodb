\name{mongo.bson.buffer.create}
\alias{mongo.bson.buffer.create}
\title{Create an new mongo.bson.buffer object}
\usage{
  mongo.bson.buffer.create()
}
\value{
  A fresh \link{mongo.bson.buffer} object
}
\description{
  Returns a fresh mongo.bson.buffer object ready to have
  data appended onto it.
}
\details{
  mongo.bson.buffer objects are used to build mongo.bson
  objects.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Donna")
b <- mongo.bson.from.buffer(buf)
}
\seealso{
  \link{mongo.bson},\cr \link{mongo.bson.buffer}.
}

