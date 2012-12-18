define [
  'backbone',
  'jquery'
], (backbone, $) ->

  # Lifecycle goals:
  # init     : Set any fields that have their data already available
  # inited   :
  # load     : Fire off async requests for data (eg: fetching models)
  # loaded   : Data available, set @locals for template
  # render   : template rendered, start adding subviews
  # rendered : Entire view and subviews are rendered
  # appear   : View is about to be added to the document
  # appeared : View has just been added to the document

  class View extends backbone.View
    constructor: ->
      super
      @_waits = []
      @_subviews = []
      @_live = false

      # Core events (load, render, appear) can trigger multiple times
      # to allow for tiered loading. Any @waitOn statements will
      # cause the current event to "fail" conceptually, and the view will
      # trigger it again once the new @waitOns have resolved. Once there are
      # no more async actions to wait for, the event is complete
      lifeCycle = (evt, evtEnd) ->
        @trigger evt
        waitLoop evt, evtEnd

      waitLoop = (evt, evtEnd) ->
        $.when.apply($, @_waits).then ->
          @_waits = []
          @trigger evt
          if @_waits.length == 0 then @trigger evtEnd else waitLoop evt

      # Meaty functions
      render = ->
        @$el.html @template @locals
      attach = ->
        @parentElement.append @el
        @_live = true

      # Chain the lifecycle events
      @once 'inited', -> lifeCycle 'load', 'loaded'
      @once 'loaded', -> lifeCycle 'render', 'rendered'
      @once 'rendered', -> lifeCycle 'appear', 'appeared'

      # Core methods for framework
      # init event starts the whole chain of events
      @once 'init', -> @trigger 'inited'

      # render events should at least have the views template rendered so that
      # we can render subviews into it. To this end we make the first 'render'
      # listener create the elements.
      @once 'render', ->
        render()
        @on 're-render', render

      # Appearing shouldn't happen till the parent has appeared.
      @once 'appear', ->
        if @parent? and !@parent._live
          @waitOn @parent.eventDeferred 'appeared'

      @once 'appeared', attach

      # Shortcut methods for devs:
      for evt in ['load', 'loaded', 'render', 'rendered', 'appear', 'appeared']
        @once evt, @[evt]

    # Helper method for turning an event into a deferred that can be waited on.
    eventDeferred: (evt) ->
      dfd = $.Deferred()
      @once evt, dfd.resolve
      dfd.promise()

    waitOn: (dfd) ->
      @_waits.push dfd

    append: (target, view) ->
      if typeof target == "string"
        target = @$el.find target

      view.parent = this
      view.parentElement = target

      @subviews.push view

      view.trigger 'init'

      # Return a deferred that resolves when the view renders so the caller
      # can wait on it.
      view.eventDeferred 'rendered'

