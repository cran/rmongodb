
## ----, eval=FALSE--------------------------------------------------------
## install.packages("rmongodb")


## ----, eval=FALSE--------------------------------------------------------
## library(devtools)
## install_github("rmongodb", "mongosoup")


## ------------------------------------------------------------------------
library(rmongodb)


## ------------------------------------------------------------------------
mongo <- mongo.create()
mongo
mongo.is.connected(mongo)


## ----, echo=FALSE--------------------------------------------------------
# load some data
library(jsonlite)
data(zips)
res <- list(length(dim(zips)[1]))
for(i in 1:dim(zips)[1]){
  tmp <- zips[i,] 
  res[[i]] <- mongo.bson.from.list(tmp)
}
mongo.insert.batch(mongo, "rmongodb.zips", res )


## ------------------------------------------------------------------------
mongo.get.databases(mongo)


## ------------------------------------------------------------------------
db <- "rmongodb"
coll <- "rmongodb.zips"
mongo.get.database.collections(mongo, db)


## ------------------------------------------------------------------------
mongo.count(mongo, coll)


## ------------------------------------------------------------------------
res <- mongo.distinct(mongo, coll, "city")
head(res)


## ------------------------------------------------------------------------
cityone <- mongo.find.one(mongo, coll, '{"city":"COLORADO CITY"}')
cityone
mongo.bson.to.list(cityone)


## ------------------------------------------------------------------------
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "city", "COLORADO CITY")
query <- mongo.bson.from.buffer(buf)
query
mongo.bson.from.JSON('{"city":"COLORADO CITY"}')


## ------------------------------------------------------------------------
pop <- mongo.distinct(mongo, coll, "pop")
hist(pop)
boxplot(pop)

mongo.count(mongo, coll, '{"pop":{"$lte":2}}')
pops <- mongo.find.all(mongo, coll, '{"pop":{"$lte":2}}')
head(pops)
dim(pops)


## ------------------------------------------------------------------------
library(jsonlite)
json <- '{"pop":{"$lte":2}, "pop":{"$gte":1}}'
cat(prettify(json))
validate(json)
mongo.count(mongo, coll, json)
pops <- mongo.find.all(mongo, coll, json)
head(pops)
dim(pops)

# still inefficient!
mongo.cursor.to.data.frame


## ------------------------------------------------------------------------
# insert data
icoll <- paste(db, "test", sep=".")
a <- mongo.bson.from.JSON( '{"ident":"a", "name":"Markus", "age":33}' )
b <- mongo.bson.from.JSON( '{"ident":"b", "name":"MongoSoup", "age":1}' )
c <- mongo.bson.from.JSON( '{"ident":"c", "name":"UseR", "age":18}' )
mongo.insert.batch(mongo, icoll, list(a,b,c) )

mongo.get.database.collections(mongo, db)
mongo.find.all(mongo, icoll)


## ------------------------------------------------------------------------
mongo.update(mongo, icoll, '{"ident":"b"}', '{"$inc":{"age":3}}' )

mongo.find.all(mongo, icoll)


## ------------------------------------------------------------------------
mongo.index.create(mongo, icoll, '{"ident":1}')
# check mongoshell!


## ------------------------------------------------------------------------
mongo.drop(mongo, icoll)
mongo.drop.database(mongo, db)
mongo.get.database.collections(mongo, db)

# close connection
mongo.destroy(mongo)


## ------------------------------------------------------------------------
mongo <- mongo.create()


## ------------------------------------------------------------------------
data(zips)
head(zips)
zips[1,]$loc

res <- list(length(dim(zips)[1]))
for(i in 1:dim(zips)[1]){
  tmp <- zips[i,] 
  res[[i]] <- mongo.bson.from.list(tmp)
}
mongo.insert.batch(mongo, "rmongodb.zips", res )

mongo.count(mongo, icoll)
mongo.find.all(mongo, icoll)


## ------------------------------------------------------------------------
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.object(buf, "$group")
mongo.bson.buffer.append(buf, "_id", "$state")
mongo.bson.buffer.start.object(buf, "totalPop")
mongo.bson.buffer.append(buf, "$sum", "$pop")
mongo.bson.buffer.finish.object(buf)
mongo.bson.buffer.finish.object(buf)
bson <- mongo.bson.from.buffer(buf)

bufall <- mongo.bson.buffer.create()
mongo.bson.buffer.append(bufall, "aggregate", "zips")
mongo.bson.buffer.start.array(bufall, "pipeline")
mongo.bson.buffer.append(bufall, "0", bson)
mongo.bson.buffer.finish.object(bufall)
cmd <- mongo.bson.from.buffer(bufall)
cmd
res <- mongo.command(mongo, db, cmd)
res


## ------------------------------------------------------------------------
mgrids <- mongo.gridfs.create(mongo, db, prefix = "fs")
mongo.gridfs.store.file(mgrids, "faust.txt", "Faust")
gf <- mongo.gridfs.find(mgrids, "Faust")
mongo.gridfile.get.length(gf)
mongo.gridfile.get.chunk.count(gf)



# close connection
mongo.drop.database(mongo, db)
mongo.destroy(mongo)


