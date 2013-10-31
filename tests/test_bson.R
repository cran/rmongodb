library(rmongodb)
library(RUnit)


# test create bson object with values
r <- as.integer(c(1,2,3,4,5,6,7,8))
dim(r) <- c(2,2,2)
t <- Sys.time()
t <- c(t, t+10, t+60, t+120)
dim(t) <- c(2,2)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.int(buf, "test", r)
mongo.bson.buffer.append(buf, "times", t)
b <- mongo.bson.from.buffer(buf)

checkEquals(mongo.bson.value(b, "test"), r)
checkEqualsNumeric(mongo.bson.value(b, "times"), t, tolerance=1.0e-6)



# test create bson oject with raw data
r <- as.raw(r)
dim(r) <- c(2,4)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "test", r)
b <- mongo.bson.from.buffer(buf)

checkEquals( typeof(mongo.bson.value(b, "test")), "raw")


# test create bson with list
r <- 1:24
dim(r) <- c(3,2,4)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.int(buf, "test", r)
b <- mongo.bson.from.buffer(buf)

checkEquals( mongo.bson.value(b, "test"), r)


# test create bson from data frame
age <- c(5, 8)
height <- c(35, 47)
d <- data.frame(age=age,height=height)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.object(buf, "table", d)
b <- mongo.bson.from.buffer(buf)

#checkEquals(  as.data.frame(mongo.bson.value(b, "table")), d)



# test create bson from list
age=18:29
height=c(76.1,77,78.1,78.2,78.8,79.7,79.9,81.1,81.2,81.8,82.8,83.5)
village=data.frame(age=age,height=height)
unclass(village)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.object(buf, "village", village)
b <- mongo.bson.from.buffer(buf)
print(b)

v <- mongo.bson.value(b, "village")
v
unclass(v)

#checkEquals(v, village)
