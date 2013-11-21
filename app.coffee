express = require('express')
app = express()

app.use require('connect-assets')()

app.set 'view options', { layout: false }

app.get '/', (req,res) ->
    res.render 'index.jade', { pageTitle: 'minventure!' }

port = process.env.PORT || 1337

app.listen port, ->
    console.log "Listening on #{port}"

