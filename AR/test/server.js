var express = require('express');
var app = express();
var cors = require('cors')
app.use(cors({
    origin: '*',
    credentials: true,            //access-control-allow-credentials:true
    optionSuccessStatus: 200,
}));
app.use(express.static('build'));


app.get("/", function (req, res) {
    console.log(req.query.code)
    res.sendFile(__dirname + "/" + "build/entry.html");
})

app.listen(1234)