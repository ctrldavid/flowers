express = require 'express'
jade = require 'jade'
fs = require 'fs'
coffee = require 'coffee-script'

app = express()
app.set 'views', ''

frameworkPath = 'public/'
applicationPath = '../client/public/'

app.get /^\/(.*)\.js$/, ({params: [filename]}, res) ->
  console.log 'JS:', filename
  filePaths = []
  for path in [frameworkPath, applicationPath]  # App files take precedence
    for ext in ['coffee', 'jade', 'js']
      filePath = path + filename + '.' + ext
      filePaths.push {ext, filePath}

  tryPath = ->
    {filePath, ext} = filePaths.pop()
    console.log 'Trying: ', filePath
    if filePath
      fs.stat filePath, (err, stats) ->
        if err || not stats.isFile()
          tryPath()
        else
          fs.readFile filePath, (err, data) ->
            if err
              tryPath()
            else
              res.contentType 'js'
              switch ext
                when 'js'
                  response = data
                when 'coffee'
                  response = coffee.compile data.toString()
                when 'jade'
                  template = jade.compile data.toString(), {pretty: false, client: true, compileDebug: false}
                  response = "define(['vendor/jade.runtime'],function(){return #{template};});"
              res.send response
    else
      res.send 'wat?'

  tryPath()

app.get '*', (req, res) ->
  res.render 'public/index.jade'

app.listen 3000
