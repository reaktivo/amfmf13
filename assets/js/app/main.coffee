#= require ../vendor/page
#= require ../vendor/closest-to-scroll
#= require ../vendor/jquery.smooth-scroll

class window.Main

  history: yes
  title: "All My Friends 2013"
  mobile: Modernizr.mq 'only screen and (max-width : 320px)'
  colors: "#fe2dd8 #fcb265 #0c8ffa #a5d0b1 #3dfd11 #84ebcd #fad63e #f28dae".split ' '

  constructor: ->

    ### Setup History ###
    if Modernizr.history
      $('*[data-path]').closestToScroll (el) =>
        return unless @history
        { path } = el.data()
        if document.location.pathname isnt path
          window.history.replaceState null, null, path
      page "/", @top
      page "/lineup", @lineup
      page "/band/:band", @band
      do page.start

    ### Setup mouse event handlers ###
    $('a.lineup').smoothScroll()
    $('#lineup a').on
      mouseover: (e) => $(e.currentTarget).css color: @color()
      mouseout: (e) => $(e.currentTarget).css color: ''
    $('a.partners').click @partners
    $('a.listen').click @listen

    ### Setup layout ###
    @offset = if @mobile then 0 else -40
    $('#partners').hide()
    do @layout

  top: ->
    $.smoothScroll()

  listen: (e) =>
    link = $(e.currentTarget)
    embed = link.data 'embed'
    if embed
      e.preventDefault()

      # Set current text label
      link.text 'Cargando...'

      # find band's embed container
      el = link.closest('.band').find('.embed')

      # load and open
      el.hide().html(embed).find('iframe').load =>
        el.slideDown()
        link.parent().slideUp()
        if @mobile then $.smoothScroll scrollTarget: link, offset: @offset

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

  color: =>
    @colors[Math.floor(Math.random() * @colors.length)]

$(document).ready ->
  window.app = {}
  window.app.main = new window.Main