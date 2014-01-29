\name{mongo.cursor.to.list}
\alias{mongo.cursor.to.list}
\title{Convert Mongo Cursor Object to List}
\usage{
mongo.cursor.to.list(cursor, nullToNA = TRUE)
}
\arguments{
  \item{cursor}{(\link{mongo.cursor}) A mongo.cursor object
  returned from \code{\link{mongo.find}()}.}

  \item{nullToNA}{(boolean) If \code{NULL} values will be
  torned into \code{NA} values. Usually this is a good
  idea, because sporadic \code{NULL} values will cause
  structural problems in the data.frame, whereas \code{NA}
  values will just appear as regular \code{NA}s.}
}
\value{
An R list object.
}
\description{
Converts a mongo cursor object to a list by interating over
all cursor objects and combining them.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "age", 22L)
    query <- mongo.bson.from.buffer(buf)

    # Find the first 100 records
    #    in collection people of database test where age == 22
    cursor <- mongo.find(mongo, "test.people", query, limit=100L)

    res <- mongo.cursor.to.list(cursor)

}
}
\seealso{
\code{\link{mongo.find}},\cr
\code{\link{mongo.bson.to.list}}.
}

