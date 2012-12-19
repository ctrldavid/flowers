define [
  '$'
  'bbx/view'
  'bbx/application'
  'index'
], ($, View, Application, indexTpl) ->

  class Flowers extends Application
    template: indexTpl
    render: ->
      @waitOn @append '.js-flowers', new FlowerView

    appeared: ->
      window.setInterval =>
        @append '.js-flowers', new FlowerView
      , 300

  class FlowerView extends View
    template: (locals) ->
      ""+locals.symbol+""

    className: 'flower'
    tagName: 'pre'

    init: ->
      @symbols = [
        "X"
        "#"
        "O"
        "+"
      ]

    loaded: ->
      @locals.symbol = @symbols[(Math.random()*@symbols.length)|0]


  (new Flowers).start()


