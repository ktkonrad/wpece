{exec} = require "child_process"
util = require "util"

task "app", "compile app.js", ->
  exec "coffee --bare app.js", (err, stdout, stderr) ->
    util.log err if err
    util.log "Compiled app.js"

task "watch", "watch app.js", ->
  exec "coffee --watch --bare app.js", (err, stdout, stderr) ->
    util.log err if err
    util.log "Watching app.js"
