rmongodb
===================

This is an R (www.r-project.org) extension supporting access to MongoDB (www.mongodb.org) using the mongodb-c-driver (http://docs.mongodb.org/ecosystem/drivers/c/).

The latest stable version is available on **CRAN**: http://cran.r-project.org/package=rmongodb

Thanks to Gerald Lindsly and MongoDB, Inc. (formerly 10gen) for the initial work. 
In October 2013, **MongoSoup** (www.mongosoup.de) has overtaken the development and maintenance of the R package. 

Please feel free to send us issues or pull requests via github: https://github.com/mongosoup/rmongodb

Furthermore, we are happy to get your feedback personally via email: markus@mongosoup.de



Usage
==================
Once you have installed the package, it may be loaded from within R like any other package:

    library("rmongodb")
    
    # connect to your local mongodb
    mongo <- mongo.create()
    
    # create query object 
    query <- mongo.bson.from.JSON('{"age": 27}')

    # Find the first 100 records
    #    in collection people of database test where age == 27
    cursor <- mongo.find(mongo, "test.people", query, limit=100L)
    # Step though the matching records and display them
    while (mongo.cursor.next(cursor))
        print(mongo.cursor.value(cursor))
    mongo.cursor.destroy(cursor)
    
    res <- mongo.find.batch(mongo, "test.people", query, limit=100L)
    
    mongo.disconnect(mongo)
    mongo.destroy(mongo)

There is also one demo available:
  
    library("rmongodb")
    demo(teachers_aid)


### Supported Functionality by rmongodb
* Connecting and disconnecting to MongoDB
* Querying, inserting and updating to MongoDB including with **JSON** and BSON
* Creating and handling BSON objects
* Dropping collections and databases on MongoDB
* Creating indices on MongoDB collections
* Error handling
* Executing commands on MongoDB
* Adding, removing, handling files on a "Grid File System" (GridFS) on a 
MongoDB server
* High Level functionality as mongo.apply, mongo.summary, mongo.get.keys, ...


### Good ressources to Get Started with rmongodb
* *Basic Overview of using the rmongodb package for R* - December 2013, Brock Tibert  
  code examples: https://gist.github.com/Btibert3/7751989

* *R with MongoDB* - MongoDB Munich conference, October 2013, Markus Schmidberger
  * video: http://www.youtube.com/watch?v=RR3UxemmJ1Q
  * slides: http://rpubs.com/schmidb/rstatsMongoDB

* *Accessing mongodb from R* - January 2012, Sean Davis  
  code examples: http://watson.nci.nih.gov/~sdavis/blog/rmongodb-using-R-with-mongo/

* *R and MongoDB* - June 2013, WenSui  
  example comparing rmongodb and RMongo: http://www.r-bloggers.com/r-and-mongodb/
 
* *rmongodb – R Driver for MongoDB* - September 2011, Gerald Lindsly  
  blog post: http://www.r-bloggers.com/rmongodb-r-driver-for-mongodb/

* Stackoverflow questions and answers:  
  http://stackoverflow.com/questions/tagged/rmongodb


### Good ressources to Install and Get Started with MongoDB
* *Installing MongoDB*, MongoDB Doku  
  http://docs.mongodb.org/manual/installation/

* *Getting Started with MongoDB*, MongoDB Doku  
  http://docs.mongodb.org/manual/tutorial/getting-started/

* *MongoDB - Getting Started Guide*, April 2013, Satish
  * blog post: http://technotip.com/2982/mongodb-getting-started-guide/
  * Video: http://www.youtube.com/watch?v=J2qnq8WI6EU

### Good ressources for working with JSON-Data in R:
* There are three R packages on CRAN: RJSONIO, jsonlite (used by rmongodb) and rjson
* jsonlite vignette for using JSON in R: http://cran.r-project.org/web/packages/jsonlite/vignettes/json-mapping.pdf



Development
==================

To install the development version of rmongodb, it's easiest to use the devtools package:

    # install.packages("devtools")
    library(devtools)
    install_github("rmongodb", "mongosoup")
    
We advice using RStudio (www.rstudio.org) for the package development. The RStudio .Rproj file is included in the repository.

### Usefull links
* BSON specification: http://bsonspec.org/#/specification

### Versioning
We use a three step version number system, e.g. v1.2.1:
* first: major changes as new C libraries
* second: for each new stable CRAN release
* third: for each new github version ready for testing

### General Development Rules
* we use roxygen2
* we write RUnit tests for all new functionality in tests/test_XXX.R
* for bigger changes we use branches
* CRAN submission:
 * http://cran.r-project.org/submit.html
 * create Package tar.gz via RStudio "Build Source Package"
 * run R CRAN checks via: R CMD check --as-cran package.tar.gz
 * run R CRAN checks without running mongodb installation
 * create a tag / release on github for every CRAN submission