config = require "./config"
mongoose = require "mongoose"
bcrypt = require "bcrypt"

mongoose.connect "mongodb://#{config.mongo.host}/#{config.mongo.database}", (err) -> console.log err if err

## helpers
validate_email = (val) -> not val or (/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).test(val)

# returns a function that does a find or create with for the given source
findOrCreateWith = (model, source) =>
  (session, accessToken, accessTokExtra, userMetadata, promise) ->
    console.log userMetadata
    condition = {}
    condition["#{source}Id"] = userMetadata.id
    model.findOne condition, (err, user) =>
      if err
        console.log err
        return promise.fail err
      if user
        promise.fulfill user
      else
        user = new model()
        user["#{source}Id"] = userMetadata.id
        user.name = userMetadata.name
        user.email = userMetadata.email
        user.save (err) ->
          if err
            console.log err
            return promise.fail err
          promise.fulfill(user)

## schemas
Schema = mongoose.Schema
UserSchema = new Schema {
  email: {
    type: String,
    validate: [validate_email, 'email']
  }            
  name: String,
  facebookId: String,
  googleId: String,
  salt: String,
  password: String
}
User = mongoose.model('User', UserSchema);
UserSchema.methods.setPassword = (password) ->
  savePassword = (password, salt) =>
    bcrypt.hash password, salt, (err, hashed) =>
      return console.log err if err
      @password = hashed
      @save()
  if @salt
    # store salted and hashed password
    savePassword(password, @salt)
  else
    # generate salt
    bcrypt.genSalt (err, salt) =>
      return console.log err if err
      @salt = salt
      savePassword(password, @salt)

UserSchema.methods.verifyPassword = (password, res) ->
  bcrypt.hash password, @salt, (err, hashed) =>
    console.log err if err
    if @password and hashed is @password
      res.send 'success'
    else
      res.send 'failed', 401

UserSchema.statics.findOrCreateFacebook = findOrCreateWith(User, 'facebook')
UserSchema.statics.findOrCreateGoogle = findOrCreateWith(User, 'google')


module.exports = {User}