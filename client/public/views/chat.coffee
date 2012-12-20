define [
  'bbx/view'
  'templates/chat/window'
  'templates/chat/message'
], (View, windowTpl, messageTpl) ->

  class ChatRoomView extends View
    template: windowTpl
    events:
      'keydown .js-message': 'keyPress'
    keyPress: (e) ->
      if e.keyCode == 13
        input = @$el.find '.js-message'
        message = input.val()
        input.val('')
        messageView = new ChatMessageView model: {user:'me', message}
        @append '.js-messages', messageView


  class ChatMessageView extends View
    template: messageTpl
    loaded: ->
      @locals.message = @model.message
      @locals.user = @model.user

  return {ChatRoomView}
