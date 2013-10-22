#= require ../vendor/page
#= require ../vendor/closest-to-scroll
#= require ../vendor/jquery.smooth-scroll

class window.Main

  history: yes
  title: "All My Friends 2013"
  mobile: Modernizr.mq 'only screen and (max-width : 320px)'
  colors: "#fe2dd8 #fcb265 #0c8ffa #a5d0b1 #3dfd11 #84ebcd #fad63e #f28dae".split ' '

  constructor: ->

    ### Setup element references ###
    @window = $ window
    @lineup = $ '#lineup'
    @lineup_link = $ '#lineup-link'
    @indio = $ '.indio-presenta'
    @partners = $ '#partners'

    ### Setup layout ###
    @partners.hide()
    do @layout

    ### Setup History ###
    if Modernizr.history
      $('*[data-path]').closestToScroll (el) =>
        return unless @history
        { path } = el.data()
        if document.location.pathname isnt path
          window.history.replaceState null, null, path
          do @update_lineup_link
      page "/", @top
      page "/lineup", @lineup_scroll
      page "/band/:band", @band
      do page.start

    ### Setup mouse event handlers ###
    $('a.lineup').smoothScroll()
    $('a', @lineup).on
      mouseover: (e) => $(e.currentTarget).css color: @color()
      mouseout: (e) => $(e.currentTarget).css color: ''
    $('a.partners').click @toggle_partners
    $('a.listen').click @listen

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

  lineup_scroll: =>
    $.smoothScroll
      scrollTarget: @lineup
      offset: @offset
      afterScroll: @update_lineup_link

  update_lineup_link: =>
    opacity = +(document.location.pathname.indexOf('band') isnt -1)
    @lineup_link.animate { opacity }

  band: (ctx) =>
    do @update_lineup_link
    $.smoothScroll
      scrollTarget: ".band.#{ctx.params.band}"
      speed: 1 if ctx.init
      beforeScroll: =>
        @history = no
      afterScroll: =>
        @history = yes
        do @update_lineup_link

  toggle_partners: (e) =>
    e.preventDefault()
    @partners.slideToggle()
    $.smoothScroll scrollTarget: @partners, offset: @offset

  viewport: ->
    if typeof window.innerWidth is 'undefined'
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    else
      width: window.innerWidth
      height: window.innerHeight

  layout: =>
    if @mobile
      @offset = 0
      { width, height } = @viewport()
      $('band').css { width, height }
      @indio.hide()
    else
      @indio_threshold = @lineup.offset().top - @indio.outerHeight(yes)
      @offset = -20
      @window.scroll (e) =>
        top = @window.scrollTop()
        if top > @indio_threshold
          @indio.css position: 'absolute', top: @indio_threshold
        else
          @indio.css position: 'fixed', top: 0


  color: =>
    @colors[Math.floor(Math.random() * @colors.length)]

$(document).ready ->
  window.app = {}
  window.app.main = new window.Main