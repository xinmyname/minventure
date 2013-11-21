express = require('express')
app = express()

app.use require('connect-assets')()

app.set 'view options', { layout: false }

app.get '/', (req,res) ->
    res.render 'index.jade', { pageTitle: 'minventure!' }

app.use '/lib', express.static __dirname + '/bower_components'

port = process.env.PORT || 1337

app.listen port, ->
    console.log "Listening on #{port}"

