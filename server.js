 const express = require("express");
 const path = require("path");
const mongoose = require("mongoose");
const bodyParser = require("body-parser"); // added to parse request body

const app = express();

// body-parser middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// MongoDB connection
const mongoURI = "mongodb+srv://thisara69:thi123@thisara.yt1hoec.mongodb.net/?retryWrites=true&w=majority";
mongoose
  .connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// User model
const User = require("./models/user");

// Routes
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname + "/index.html"));
});

app.get("/admin", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "admin.html"));
});

app.get("/login", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "login.html"));
});

app.get("/signup", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "signup.html"));
});

app.get("/vote", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "vote.html"));
});

app.get("/views/signup.html", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "signup.html"));
});

app.get("/views/adminlog.html", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "adminlog.html"));
});

app.post("/signup", (req, res) => {
  var  { name, password } = req.body;

  // create a new user document
  var newUser = new User({ name, password });

  // save the user document to the database
  newUser
    .save()
    .then(user => {
      console.log(`User ${user.name} saved to the database`);
      res.sendFile(path.join(__dirname, "views", "vote.html"));
    })
    .catch(err => {
      console.log(err);
      res.redirect("/signup");
    });
});

app.post("/login", (req, res) => {
  var { name, password } = req.body;

  // find the user document with the matching name and password
  User.findOne({ name, password })
    .then(user => {
      if (user) {
        // user exists, so redirect to the vote page
        res.sendFile(path.join(__dirname, "views", "vote.html"));
      } else {
        // user does not exist, so redirect to the login page
        res.redirect("/");
      }
    })
    .catch(err => {
      console.log(err);
      res.redirect("/");
    });
});


// Server setup
const server = app.listen(5000);
const portNumber = server.address().port;
console.log("port: " + portNumber);



