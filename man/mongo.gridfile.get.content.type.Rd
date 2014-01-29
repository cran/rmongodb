\name{mongo.gridfile.get.content.type}
\alias{mongo.gridfile.get.content.type}
\title{Get the content type of a mongo.gridfile}
\usage{
mongo.gridfile.get.content.type(gridfile)
}
\arguments{
  \item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(string) The content.type (remote name) of \code{gridfile}.
This may be an empty string if no content type is
associated with the gridfile.
}
\description{
Get the MIME content type of a \link{mongo.gridfile}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    mongo.gridfs.store.file(gridfs, "tests/test.R", "test.R")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    if( !is.null(gf)){
      print(mongo.gridfile.get.content.type(gf))

      mongo.gridfile.destroy(gf)
    }
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs}},\cr
\code{\link{mongo.gridfs.find}},\cr
\link{mongo.gridfile},\cr
\code{\link{mongo.gridfile.get.descriptor}},\cr
\code{\link{mongo.gridfile.get.filename}},\cr
\code{\link{mongo.gridfile.get.length}},\cr
\code{\link{mongo.gridfile.get.chunk.size}},\cr
\code{\link{mongo.gridfile.get.chunk.count}},\cr
\code{\link{mongo.gridfile.get.upload.date}},\cr
\code{\link{mongo.gridfile.get.md5}},\cr
\code{\link{mongo.gridfile.get.metadata}},\cr
\code{\link{mongo.gridfile.get.chunk}},\cr
\code{\link{mongo.gridfile.get.chunks}},\cr
\code{\link{mongo.gridfile.read}},\cr
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}

