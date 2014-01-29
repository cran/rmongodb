\name{mongo.gridfile.read}
\alias{mongo.gridfile.read}
\title{Read raw data from a mongo.gridfile}
\usage{
mongo.gridfile.read(gridfile, size)
}
\arguments{
  \item{gridfile}{A (\link{mongo.gridfile}) object.}

  \item{size}{(as.double) The number of bytes to read.}
}
\value{
(raw) The data read from emphgridfile. The length of this
vector may be less than the requested size if there was not
enough data remaining to be read. This length could also be
0 if an error occured during the operation. Check
\code{\link{mongo.get.err}()} of the associated mongo
connection object in this case.
}
\description{
Read raw data from a \link{mongo.gridfile}.  The data read
may span multiple chunks.
}
\details{
A mongo.gridfile file maintains a current read position
which is advanced by the size of each read.  This position
is initially at offset 0.

Since this function returns raw data, you may want to use
R's \code{readBin()} to unpack it.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    mongo.gridfs.store.file(gridfs, "tests/test.R", "test.R")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    if( !is.null(gf)){
      mongo.gridfile.seek(gf, 256*256*5)
      data <- mongo.gridfile.read(gf, 16384)

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
\code{\link{mongo.gridfile.get.content.type}},\cr
\code{\link{mongo.gridfile.get.upload.date}},\cr
\code{\link{mongo.gridfile.get.md5}},\cr
\code{\link{mongo.gridfile.get.metadata}},\cr
\code{\link{mongo.gridfile.get.chunk}},\cr
\code{\link{mongo.gridfile.get.chunks}},\cr
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}

