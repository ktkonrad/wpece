# requires
fs = require("fs")
express = require("express")
jade = require("jade")
db = require("./lib/db")

# initialization
app = express.createServer()
app.set "view options", layout: false
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()

# serve static assets in /public
app.use express.static(__dirname + "/../public")

# render index page
app.get "/", (req, res) -> res.render "index.jade"

# serve it
app.listen 10000
console.log "Serving on port 10000"
