#= require ../vendor/page
#= require ../vendor/closest-to-scroll
#= require ../vendor/jquery.smooth-scroll

class window.Main

  history: yes
  title: "All My Friends 2013"

  constructor: ->
    if Modernizr.history
      $('.band').closestToScroll (el) =>
        return unless @history
        if el is null
          path = "/"
        else
          { slug } = el.data()
          path = "/bands/#{slug}"
        if document.location.pathname isnt path
          window.history.replaceState null, null, path
    $('a.lineup').smoothScroll()
    page "/", @top
    page "/lineup", @lineup
    page "/bands/:band", @band
    do page
    do @layout
  top: ->
    $.smoothScroll()
  lineup: ->
    $.smoothScroll scrollTarget: "#lineup"
  band: (ctx) =>
    $.smoothScroll
      scrollTarget: ".band.#{ctx.params.band}"
      beforeScroll: => @history = no
      afterScroll: => @history = yes
  viewport: ->
    if typeof window.innerWidth is 'undefined'
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    else
      width: window.innerWidth
      height: window.innerHeight
  layout: ->
    if Modernizr.mq 'only screen and (max-width : 320px)'
      size = @viewport()
      console.log size
      $('band').css {size}

$(document).ready ->
  window.app = {}
  window.app.main = new window.Main