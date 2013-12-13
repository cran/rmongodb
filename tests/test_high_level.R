library(rmongodb)
library(RUnit)

# 2 tests
# 13.12.2013

# set up mongoDB connection and db / collection parameters
mongo <- mongo.create()
db <- "rmongodb"
ns <- paste(db, "test_high_level", sep=".")

if( mongo.is.connected(mongo) ){
  
  # clean up old existing collection
  mongo.drop(mongo, ns)
  
  mongo.insert(mongo, ns, '{"name":"Peter", "city":"Rom"}')
  mongo.insert(mongo, ns, '{"name":"Markus", "city":"Munich", "age":51}')
  mongo.insert(mongo, ns, '{"name":"Tom", "city":"London", "age":1}')
  mongo.insert(mongo, ns, '{"name":"Jon", "age":23}')
  
  res <- mongo.distinct(mongo, ns, "name")
  checkEquals(as.vector(res), c("Peter", "Markus", "Tom", "Jon"))
  
  res <- mongo.distinct(mongo, ns, "age")
  checkEquals(as.vector(res), c(51,1,23))
  
  # cleanup db and close connection
  mongo.drop.database(mongo, db)
  mongo.destroy(mongo)
}

