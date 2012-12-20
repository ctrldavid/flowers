define [
  '$'
  'bbx/view'
  'bbx/application'
  'index'
  'views/chat'
], ($, View, Application, indexTpl, {ChatRoomView}) ->

  class Flowers extends Application
    template: indexTpl
    render: ->
      @waitOn @append '.js-chat', new ChatRoomView




  (new Flowers).start()


