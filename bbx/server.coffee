express = require 'express'
jade = require 'jade'
fs = require 'fs'
coffee = require 'coffee-script'

app = express()
app.set 'views', ''

frameworkPath = 'public/'

app.get /^\/(.*)\.js$/, ({params: [filename]}, res) ->
  console.log 'JS:', filename

  for path in [frameworkPath]
    for ext in ['coffee', 'jade', 'js']
      filePath = path + filename + '.' + ext
      do (filePath, ext) ->
        fs.stat filePath, (err, stats) ->
          if !err && stats.isFile()
            fs.readFile filePath, (err, data) ->
              unless err
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


app.get '*', (req, res) ->
  res.render 'public/bbx.jade'

app.listen 3000
