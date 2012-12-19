define [
  '$'
  'bbx/view'
  'bbx/application'
], ($, View, Application) ->

  class ExampleApp extends Application
    template: -> "<h3>BBX Example App</h3><div class='js-messages'></div>"
    render: ->
      @messageView = new MessageView
      @waitOn @append '.js-messages', @messageView

    appeared: ->
      window.setInterval =>
        @append '.js-messages', new MessageView
      , 1000

  class MessageView extends View
    template: (locals) ->
      "<pre style='margin:0px 8px;float:left;'>"+locals.message+"</pre>"

    init: ->
      @messages = [
        "Pants for everyone"
        "Yay pants"
        "Wat pants?"
        "These pants!"
      ]

    loaded: ->
      @locals.message = @messages[(Math.random()*@messages.length)|0]


  (new ExampleApp).start()


