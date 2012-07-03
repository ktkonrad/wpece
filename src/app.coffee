# requires
fs = require("fs")
express = require("express")
jade = require("jade")
models = require("./models")

# initialization
app = express.createServer()
app.set "view options", layout: false
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({secret: "session_secret"})

# helpers
app.dynamicHelpers {
  session: (req, res) ->
    return req.session;
  }
  
# serve static assets in /public
app.use express.static(__dirname + "/../public")

# render index page
app.get "/", (req, res) ->
  models.User.sync()
  res.render "index.jade"

# serve it
app.listen 10000
console.log "Serving on port 10000"
