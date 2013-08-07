#= require ../vendor/page
#= require ../vendor/ns

ns App:Main: class

  constructor: ->
    @window = $ window
    @content = $ '#content'
    do @animate

  animate: ->
    logo = $ ".amf-logo"
    @window.one scroll: =>
      logo.animate marginTop: 40
      logo.addClass 'small'
      @content.animate opacity: 1

    logo.css marginTop: (@viewport().height -  logo.outerHeight()) / 2
    logo.children().each (i) ->
      el = $ this
      delay = i * 400 + 100
      setTimeout (-> el.transition scale: 1, opacity: 1), delay

  viewport: ->
    if typeof window.innerWidth is 'undefined'
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    else
      width: window.innerWidth
      height: window.innerHeight

$(document).ready ->
  window.app = new App.Main