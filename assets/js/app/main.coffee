#= require ../vendor/page
#= require ../vendor/closest-to-scroll
#= require ../vendor/jquery.smooth-scroll

google.maps.visualRefresh = yes

{ Marker, Map, LatLng } = google.maps

class window.Main

  history: yes
  title: "All My Friends 2013"
  mobile: Modernizr.mq 'only screen and (max-width : 320px)'
  colors: "#fe2dd8 #fcb265 #0c8ffa #a5d0b1 #3dfd11 #84ebcd #fad63e #f28dae".split ' '

  constructor: ->
    @window = $ window
    @lineup = $ '#lineup'
    @lineup_btn = $ '#lineup-link'
    @indio = $ '.indio-presenta'
    do @setup_layout
    do @setup_history
    do @setup_events
    do @setup_map

  ### Setup ###

  setup_layout: =>
    if @mobile
      $.fn.smoothScroll.defaults.offset = 0
      { width, height } = @viewport()
      $('band').css { width, height }
      @indio.hide()
    else
      @indio_threshold = @lineup.offset().top - @indio.outerHeight(yes)
      $.fn.smoothScroll.defaults.offset = -20
      @window.scroll (e) =>
        top = @window.scrollTop()
        if top > @indio_threshold
          @indio.css position: 'absolute', top: @indio_threshold
        else
          @indio.css position: 'fixed', top: 0

  setup_history: =>
    return unless Modernizr.history

    elements = $('*[data-path]')

    elements.each (i, el) =>
      page $(el).data('path'), (ctx) =>
        $.smoothScroll
          scrollTarget: "*[data-path='#{ctx.pathname}']"
          speed: 1 if ctx.init
          beforeScroll: => @history = no and do @toggle_lineup_btn
          afterScroll:  => @history = yes and do @toggle_lineup_btn

    elements.closestToScroll (el) =>
      return unless @history
      { path } = el.data()
      if document.location.pathname isnt path
        window.history.replaceState null, null, path
        do @toggle_lineup_btn
    do page.start

  setup_events: =>
    $('a', @lineup).on
      mouseover: (e) => $(e.currentTarget).css color: @color()
      mouseout: (e) => $(e.currentTarget).css color: ''
    $('a.listen').click @listen
    $('.up a').click (e) =>
      e.preventDefault()
      scrollTop = @window.scrollTop()
      $($('*[data-marker]').get().reverse()).each ->
        $el = $ this
        if scrollTop > $el.offset().top
          console.log this
          page $el.data 'path'
          return no

  setup_map: =>
    @map = new Map $('#map-container')[0],
      center: new LatLng(32.531499, -117.05232)
      scrollwheel: no
      zoom: 15
      draggable: no
    @marker = new Marker
      position: new LatLng(32.531499, -117.05232)
      map: @map

    $(window).resize => @map.setCenter @marker.getPosition()

  ### Event Handlers ###

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
        if @mobile then $.smoothScroll(scrollTarget: link)

  toggle_lineup_btn: =>
    opacity = !document.location.pathname.match('^/(lineup)?$')
    @lineup_btn.animate { opacity }

  ### Helpers ###

  viewport: ->
    if typeof window.innerWidth is 'undefined'
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    else
      width: window.innerWidth
      height: window.innerHeight

  color: => @colors[Math.floor(Math.random() * @colors.length)]

$(document).ready ->
  window.app or= {}
  window.app.main = new window.Main