\name{zips}
\docType{data}
\alias{zips Dataset}
\alias{zips}
\title{zips Dataset}
\description{
A dataset with US zip data provided by mongodb for education.
}
\usage{
zips
}
\format{
The _id field holds the zip code as a string.

The city field holds the city.

The state field holds the two letter state abbreviation.

The pop field holds the population.

The loc field holds the location as a latitude longitude pair.
}

\source{
\url{http://media.mongodb.org/zips.json}
}
\examples{
\dontrun{
# code to create the dataset
library(RJSONIO)

json_file <- "http://media.mongodb.org/zips.json"

rL <- readLines(json_file)
zips <- NULL
for(i in rL){
  zips <- rbind(zips, fromJSON(i))
}

save(zips, file="data/zips.rda", compress="xz")
}
}

