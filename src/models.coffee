config = require("./config")
Sequelize = require("sequelize")
bcrypt = require("bcrypt")

sequelize = new Sequelize(config.mysql.database, config.mysql.user, config.mysql.password)

module.exports =
{
  'sequelize': sequelize,  
  User: sequelize.define 'User',
  {
    email: {
      type: Sequelize.STRING,
      validate: {isEmail: true}
    },
    name: Sequelize.STRING,
    facebookId: Sequelize.INTEGER,
    salt: Sequelize.STRING,
    password: Sequelize.STRING
  },
  {
    instanceMethods: {
      # save password in db, generating a salt if necessary
      setPassword: (password) ->
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
      ,
      verifyPassword: (password, res) ->
        bcrypt.hash password, @salt, (err, hashed) =>
          console.log err if err
          if @password and hashed is @password
            res.send 'success'
          else
            res.send 'failed', 401
    },
    classMethods: {
      findOrCreateFacebook: (session, accessToken, accessTokExtra, fbUserMetadata, promise) ->
        console.log fbUserMetadata
        @find({where: {facebookId: fbUserMetadata.id}})
        .success (user) =>
          if user
            promise.fulfill user
          else
            @create({name: fbUserMetadata.name, email: fbUserMetadata.email, facebookId: fbUserMetadata.id})
            .success (user) =>
              promise.fulfill user
            .fail (err) =>
              console.log err
              promise.fail err
        .fail (err) =>
          console.log err
          promise.fail(err)
    }
  }
}
