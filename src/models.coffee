config = require "./config"
mongoose = require "mongoose"
bcrypt = require "bcrypt"
mongooseAuth = require "mongoose-auth"

mongoose.connect "mongodb://#{config.mongo.host}/#{config.mongo.database}", (err) -> console.log err if err

## helpers
validate_email = (val) -> not val or (/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).test(val)

## schemas
Schema = mongoose.Schema
UserSchema = new Schema {}

###
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
###

UserSchema.plugin mongooseAuth, {
  everymodule: {
    everyauth: {
      User: -> return User
    }
  },
  facebook: {
    everyauth: {
      myHostname: config.hostname,
      appId: config.facebook.appId,
      appSecret: config.facebook.appSecret,
      redirectPath: '/'
    }
  },
  google: {
    everyauth: {
      myHostname: config.hostname,
      appId: config.google.appId,
      appSecret: config.google.appSecret,
      redirectPath: '/',
      scope: 'https://www.googleapis.com/auth/userinfo.profile'
    }
  },
  password: {
    loginWith: 'email',
    everyauth: {
      getLoginPath: '/login',
      postLoginPath: '/login',
      getRegisterPath: '/register',
      postRegisterPath: '/register',
      loginSuccessRedirect: '/',
      registerSuccessRedirect: '/'
    }
  }
}

User = mongoose.model('User', UserSchema);      

module.exports = {User}