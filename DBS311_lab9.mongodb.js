/*************************
-- Name: WAI SUN LAM
-- ID: 146691225
-- Date: 02/12/2023
-- Purpose: Lab 9 DBS311
*************************/
use college
db.students.find().forEach(printjson)
db.students.find().pretty()

//Q1
db.students.updateMany(
    {}, 
    { $set: { program: "CPA", term: 1 } }
);

//Q2
db.students.updateMany(
    {}, 
    { $set: { program: "BTTM" } }
);

//Q3
db.students.find({ name: "Jonie Raby" })
//Only one doc with the value Jonie Raby for the namefield
db.students.updateMany(
    { name: "Jonie Raby" },
    { $set: { program: "CPA" } }
);
//Only one doc is updated

//Q4
db.students.find(
    { name: "Jonie Raby" },
    { _id: 0, program: 1 }
);

//Q5
db.students.updateMany(
    { _id: { $in: [20, 22, 24] } },
    { $inc: { term: 2 } }
);

//Q6
db.students.updateMany(
    { term: 3 },
    { $unset: { term: 1} }
);


