express = require('express')
app = express()

app.use require('connect-assets')()

app.use '/', express.static __dirname + '/public'
app.use '/lib', express.static __dirname + '/bower_components'
app.use '/src', express.static __dirname + '/src'

app.get '/ver', (req, res) ->
	res.send process.version

port = process.env.PORT || 1337

app.listen port, ->
  console.log "Node " + process.version
  console.log "Listening on #{port}"

