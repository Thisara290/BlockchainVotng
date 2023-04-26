var mongoose                =require("mongoose");
var passportLocalMongoose   =require("passport-local-mongoose");

//scema

var Usersch = new mongoose.Schema({
    name:String,
    password:String,

});

Usersch.plugin(passportLocalMongoose);
var User = new mongoose.model("new1",Usersch);
//exporting
module.exports = User;



