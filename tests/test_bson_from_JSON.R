library(rmongodb)
library(RUnit)

# 10 tests
# 24.11.2013

out <- mongo.bson.from.JSON('{"name" : "Peter"}')
checkEquals(class(out), "mongo.bson")
checkEquals(mongo.bson.value(out, "name"), "Peter")

out <- mongo.bson.from.JSON('{"name" : {"firstname":"Peter"}, "age":12, "visa":[123,321] }')
checkEquals(class(out), "mongo.bson")
checkEquals(mongo.bson.value(out, "name.firstname"), "Peter")
checkEquals(mongo.bson.value(out, "age"), 12)
checkEquals(mongo.bson.value(out, "visa"), c(123,321), checkNames=FALSE)

checkException( mongo.bson.from.JSON( "{'name': 'Peter'}", "Not a valid JSON content: {'name': 'Peter'}"))

out <- mongo.bson.from.JSON( '{"a":{"b":[1,{"a":3},3]}}' )
out2 <- mongo.bson.to.list(out)
checkEquals(class(out), "mongo.bson")
checkEquals(class(out2), "list")
checkTrue( is.vector(out2$a$b) )
