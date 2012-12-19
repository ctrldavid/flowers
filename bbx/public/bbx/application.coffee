define [
  '$'
  'bbx/view'
], ($, View) ->

  class Application extends View
    start: ->
      @appendTo $ 'body'

  return Application
