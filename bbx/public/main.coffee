require.config
  shim:
    'backbone':
      deps: ['underscore', '$']
      exports: 'Backbone'
      init: () -> Backbone.noConflict()
    underscore:
      exports: '_'
      init: () -> _.noConflict()
    $:
      exports: '$'
      init: () -> $.noConflict()

  paths:
    underscore: 'vendor/underscore'
    backbone: 'vendor/backbone'
    $: 'vendor/jquery'
    moment: 'vendor/moment'

require [
 'view'
], (view) ->
