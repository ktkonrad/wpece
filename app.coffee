# requires
fs = require("fs")
express = require("express")
jade = require("jade")
mysql = require("mysql")
orm = require("orm")

# initialization
#db = orm.connect "mysql://username:password@hostname/database", (success, db) ->
#  unless success
#    console.log "Failed to connect to database"
app = express.createServer()
app.set "view options", layout: false
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()

# serve static assets in /public
app.use express.static(__dirname + "/public")

# render index page
app.get "/", (req, res) -> res.render "index.jade"

# serve it
app.listen 10000
console.log "Serving on port 10000"
