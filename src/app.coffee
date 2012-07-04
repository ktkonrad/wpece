# requires
fs = require("fs")
express = require("express")
jade = require("jade")
everyauth = require("everyauth")
models = require("./models")

#authentication
everyauth.facebook
.appId('373043746094559')
.appSecret('c8006f02927e3377bcaab056893e9f91')
.handleAuthCallbackError( (req, res) ->
# If a user denies your app, Facebook will redirect the user to
# /auth/facebook/callback?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request.
# This configurable route handler defines how you want to respond to
# that.
# If you do not configure this, everyauth renders a default fallback
# view notifying the user that their authentication failed and why.
)
.findOrCreateUser( (session, accessToken, accessTokExtra, fbUserMetadata) ->
  promise = @Promise()
  models.User.findOrCreateFacebook(session, accessToken, accessTokExtra, fbUserMetadata, promise)
  return promise;
)
.redirectPath('/');

everyauth.everymodule.findUserById (userId, callback) ->
  models.User.find({where: {id: userId}})
  .success (user) ->
    callback('', user)
  .fail (err) ->
    callback(err, {})

# initialization
app = express.createServer()
app.set "view options", layout: false
app.use express.bodyParser()
#app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({secret: "94fjf49o843a8"})
app.use everyauth.middleware()
app.use app.router
app.use express.static(__dirname + "/../public")
app.use express.errorHandler()

# helpers
everyauth.helpExpress(app);
app.dynamicHelpers {
  # make session data available in views
  session: (req, res) ->
    return req.session;
  }

# this is required to serve static assets
# otherwise app.router ends all requests
app.get "/*", (req, res, next) ->
  next()

# render index page
app.get "/", (req, res) ->
  res.render "index.jade"

app.get "/name_or_email", (req, res) ->
  if req.user
    res.send req.user.name or req.user.email or ''
  else
    res.send ''

# signin
#app.post "/signin", (req, res) ->
#  models.User.find({where: {email: req.body.email}}).success (user) ->
#    return res.send 'failed', 401 unless user
#    user.verifyPassword(req.body.password, res)

# serve it
app.listen 10000
console.log "Serving on port 10000"
