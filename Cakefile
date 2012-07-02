{exec} = require 'child_process'
    
task 'build', 'Build all source files', ->
  exec "coffee --compile --output lib/ src/", (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  console.log "Compiled all files."
