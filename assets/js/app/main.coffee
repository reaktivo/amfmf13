#= require ../vendor/page
#= require ../vendor/closest-to-scroll

class window.Main

  constructor: ->
    $('.band').closestToScroll (el) ->
      $('body').attr id: el.data('slug')

$(document).ready ->
  window.app = {}
  window.app.main = new window.Main