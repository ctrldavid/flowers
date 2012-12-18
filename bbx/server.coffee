express = require 'express'
jade = require 'jade'
fs = require 'fs'

app = express()
app.set 'views', ''

app.get '*', (req, res) ->
  res.render 'public/bbx.jade'

app.listen 3000
