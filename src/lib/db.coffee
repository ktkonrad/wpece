config = require("../config/config")
orm = require("orm")

db = orm.connect "mysql://#{config.mysql.username}:#{config.mysql.password}@#{config.mysql.host}/#config.mysql.database}", (success, db) ->
  unless success
    console.log "Failed to connect to database"

exports = db