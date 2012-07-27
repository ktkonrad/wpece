# requires
fs           = require "fs"
express      = require "express"
jade         = require "jade"
#mongooseAuth = require "mongoose-auth"
#models       = require "./models"

# initialization
app = express.createServer()
app.set "view options", layout: false
app.use express.bodyParser()
#app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({secret: "94fjf49o843a8"})
#app.use mongooseAuth.middleware()
app.use app.router
app.use express.static(__dirname + "/../public")
app.use express.errorHandler()

## routes
# 
# this is required to serve static assets
# otherwise app.router ends all requests
app.get "/*", (req, res, next) ->
  next()

# render index page
app.get "/", (req, res) ->
  res.render "index.jade"

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect('/')

# helpers
#mongooseAuth.helpExpress(app);
app.dynamicHelpers {
  # make session data available in views
  session: (req, res) ->
    req.session;
}

# serve it
app.listen 10000
console.log "Serving on port 10000"
