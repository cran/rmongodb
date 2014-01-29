library(rmongodb)
library(jsonlite)
library(RUnit)

# 10 tests
# 29.01.2014

out <- mongo.bson.from.JSON('{"name" : "Peter"}')
checkEquals(class(out), "mongo.bson")
checkEquals(mongo.bson.value(out, "name"), "Peter")

out <- mongo.bson.from.JSON('{"name" : {"firstname":"Peter"}, "age":12, "visa":[123,321] }')
checkEquals(class(out), "mongo.bson")
checkEquals(mongo.bson.value(out, "name.firstname"), "Peter")
checkEquals(mongo.bson.value(out, "age"), 12)
checkEquals(as.vector( mongo.bson.value(out, "visa") ), c(123,321))

checkException( mongo.bson.from.JSON( "{'name': 'Peter'}", "Not a valid JSON content: {'name': 'Peter'}"))

json <- '{"a":{"b":[1,{"a":3},3]}}'
cat(prettify(json))
validate(json)
out <- mongo.bson.from.JSON( json )
out2 <- mongo.bson.to.list(out)
checkEquals(class(out), "mongo.bson")
checkEquals(class(out2), "list")
checkTrue( is.vector(out2$a$b) )

