//Q1
db.student.insertOne({
    first_name: "Sarah",
    last_name: "Stone",
    email: "s_stone@email.com",
    city: "Markham",
    status: "full-time",
    gpa: 3.2,
    program: "CPA"
});

db.student.insertOne({
    first_name: "WAI SUN",
    last_name: "LAM",
    email: "wslam4@myseneca.ca",
    city: "Markham",
    status: "full-time",
    gpa: 3.8,
    program: "CPA"
});

//Q2
db.student.find();
db.student.find().forEach(printjson);
//How many fields are in your document? 8
//Is there any new field added to your document? Yes
//If yes, what is the name of the field? _id:

//Q3
db.student.find({first_name: "Sarah", last_name: "Stone"});
/*
[
    {
      "_id": {
        "$oid": "65542147e11ce5844b726847"
      },
      "first_name": "Sarah",
      "last_name": "Stone",
      "email": "s_stone@email.com",
      "city": "Markham",
      "status": "full-time",
      "gpa": 3.2,
      "program": "CPA"
    }
  ]
*/
db.student.deleteOne({first_name: "Sarah", last_name: "Stone"});
/*
{
    "acknowledged": true,
    "deletedCount": 1
}
*/

//Q4
db.student.find({ first_name: "Sarah", last_name: "Stone" });
/*
[]
*/

//Q5
var starray = [{
    _id: 1001,
    first_name: "Sarah",
    last_name: "Stone",
    email: "s_stone@email.com",
    city: "Toronto",
    status: "full-time",
    gpa: 3.4,
    program: "CPA"
},
{
    _id: 1002,
    first_name: "Jack",
    last_name: "Adam",
    email: "j_adam@email.com",
    city: "North York",
    status: "part-time",
    gpa: 3.6,
    program: "CPA"
}];

db.student.insertMany(starray);
/*
{
    "acknowledged": true,
    "insertedIds": {
      "0": 1001,
      "1": 1002
    }
}
*/

//Q6
db.student.find();
/*
[
  {
    "_id": {
      "$oid": "6554214edb606ffdbe9793de"
    },
    "first_name": "WAI SUN",
    "last_name": "LAM",
    "email": "wslam4@myseneca.ca",
    "city": "Markham",
    "status": "full-time",
    "gpa": 3.8,
    "program": "CPA"
  },
  {
    "_id": 1001,
    "first_name": "Sarah",
    "last_name": "Stone",
    "email": "s_stone@email.com",
    "city": "Toronto",
    "status": "full-time",
    "gpa": 3.4,
    "program": "CPA"
  },
  {
    "_id": 1002,
    "first_name": "Jack",
    "last_name": "Adam",
    "email": "j_adam@email.com",
    "city": "North York",
    "status": "part-time",
    "gpa": 3.6,
    "program": "CPA"
  }
]
*/

//Q7
db.student.remove ({});
/*
{
    "acknowledged": true,
    "deletedCount": 3
}
*/

//Q8
use senecaLab07 
db.dropDatabase()
//Expand the list of databases.
//Right-click on the senecaLab07 database.
//Select 'Drop Database' from the context menu.
/*Cannot drop the database from VS code*/



