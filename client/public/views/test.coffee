define [
  'bbx/view'
  'templates/test'
], (View, testTpl) ->

  class TestView extends View
    template: testTpl

  {TestView}
