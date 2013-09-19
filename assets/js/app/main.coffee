#= require ../vendor/page
#= require ../vendor/closest-to-scroll
#= require ../vendor/jquery.smooth-scroll

class window.Main

  history: yes
  title: "All My Friends 2013"
  offset: if Modernizr.mq 'only screen and (max-width : 320px)' then 0 else -20

  constructor: ->
    if Modernizr.history
      $('*[data-path]').closestToScroll (el) =>
        return unless @history
        { path } = el.data()
        if document.location.pathname isnt path
          window.history.replaceState null, null, path
    $('a.lineup').smoothScroll()
    $('a.partners').click @partners
    $('#partners').hide()
    page "/", @top
    page "/lineup", @lineup
    page "/bands/:band", @band
    do page
    do @layout
  top: ->
    $.smoothScroll()
  lineup: ->
    $.smoothScroll scrollTarget: "#lineup", offset: @offset
  band: (ctx) =>
    $.smoothScroll
      scrollTarget: ".band.#{ctx.params.band}"
      beforeScroll: => @history = no
      afterScroll: => @history = yes
  partners: (e) =>
    e.preventDefault()
    $('#partners').slideDown()
    $.smoothScroll scrollTarget: "#partners", offset: @offset
  viewport: ->
    if typeof window.innerWidth is 'undefined'
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    else
      width: window.innerWidth
      height: window.innerHeight
  layout: ->
    if @is_mobile
      { width, height } = @viewport()
      $('band').css { width, height }

$(document).ready ->
  window.app = {}
  window.app.main = new window.Main