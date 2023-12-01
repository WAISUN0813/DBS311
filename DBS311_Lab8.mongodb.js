/*************************
-- Name: WAI SUN LAM
-- ID: 146691225
-- Date: 27/11/2023
-- Purpose: Lab 8 DBS311
*************************/

db.products.find().forEach(printjson)

//Q1
db.products.find(
    {},
     {"_id": 0, "name": 1, "price": 1}
     )

//Q2
db.products.find(
    {"type": "accessory"}, 
    {"_id": 0, "name": 1, "price": 1}
    )

//Q3
db.products.find(
    {"price": {"$gte": 13, "$lte": 19}},
     {"_id": 0, "name": 1, "price": 1}
     )

//Q4
db.products.find(
    {"type":{"$ne":"accessory"}},
    {"_id": 1,"name": 1, "price": 1, "type": 1}
   )

//Q5
db.products.find(
    {"type":{"$in":["accessory", "service"]}},
    {"_id": 1,"name": 1, "price": 1, "type": 1}
   )

//Q6
db.products.find(
    { type: { $exists: true } },
    { _id: 1, name: 1, price: 1, type: 1 }
  )

//Q7
db.products.find(
    {"type":{"$all":["accessory", "case"]}},
    {"_id": 1,"name": 1, "price": 1, "type": 1}
    )
  
//Q8
/* I think MongoDB is more better than Oracle. 
It is more fixable and do not have a lot of rule need to remember how to write a code.
*/     