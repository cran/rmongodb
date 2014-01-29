\name{mongo.drop}
\alias{mongo.drop}
\title{Drop a collection from a MongoDB server}
\usage{
mongo.drop(mongo, ns)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection to
  drop.}
}
\value{
(Logical) TRUE if successful; otherwise, FALSE
}
\description{
Drop a collection from a database on MongoDB server.  This
removes the entire collection.
}
\details{
Obviously, care should be taken when using this command.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.drop(mongo, "test.people"))

    mongo.destroy(mongo)
}
}
\seealso{
\code{\link{mongo.drop.database}},\cr
\code{\link{mongo.command}},\cr
\code{\link{mongo.rename}},\cr
\code{\link{mongo.count}},\cr \link{mongo}.
}

