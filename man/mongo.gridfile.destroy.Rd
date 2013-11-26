\name{mongo.gridfile.destroy}
\alias{mongo.gridfile.destroy}
\title{Destroy a mongo.gridfile object}
\usage{
  mongo.gridfile.destroy(gridfile)
}
\arguments{
  \item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
  NULL
}
\description{
  Releases the resources associated with a
  \link{mongo.gridfile} object.\cr These are created by
  \code{\link{mongo.gridfs.find}()}.
}
\details{
  It is not absolutely necessary to call this function
  since R's garbage collection will eventually get around
  to doing it for you.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    mongo.gridfs.store.file(gridfs, "tests/test.R", "test.R")
    gf <- mongo.gridfs.find(gridfs, "test.R")
    if( !is.null(gf) ){
      print(mongo.gridfile.get.upload.date(gf))
      mongo.gridfile.destroy(gf)
    }
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
  \code{\link{mongo.gridfs.find}},\cr
  \link{mongo.gridfile},\cr \link{mongo.gridfs}.
}

