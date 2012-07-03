config = require("./config")
Sequelize = require("sequelize")

sequelize = new Sequelize(config.mysql.database, config.mysql.user, config.mysql.password)

module.exports = {
  'sequelize': sequelize,  
  User: sequelize.define 'User', {
    email: {
      type: Sequelize.STRING,
      validate: {isEmail: true}
    },
    name: Sequelize.STRING,
    salt: Sequelize.STRING,
    password: Sequelize.STRING
  }
}