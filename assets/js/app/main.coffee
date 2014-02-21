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
    @indio = $ '.indio-presenta'
    @band = $ '#band'
    do @setup_layout
    do @setup_history
    do @setup_events
    do @setup_map

  ### Setup ###

  setup_layout: =>
    @band.hide()
    if @mobile
      $.fn.smoothScroll.defaults.offset = 0
      $('band').css @viewport()
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

    page '/lineup', (ctx, next) =>
      @history = yes
      do @hide_band
      do next

    page '/band/:band', (ctx) =>
      @history = no
      @show_band ctx.params.band, ctx.init

    elements = $('*[data-path]')

    elements.each (i, el) =>
      page $(el).data('path'), (ctx) =>
        target = $ "*[data-path='#{ctx.pathname}']"
        @grab_title(target)
        $.smoothScroll
          scrollTarget: target
          speed: 1 if ctx.init
          beforeScroll: => @history = no
          afterScroll:  => @history = yes

    elements.closestToScroll (el) =>
      return unless @history
      { path } = el.data()
      if document.location.pathname isnt path
        window.history.replaceState null, null, path
        @grab_title(el)
    do page.start

  setup_events: =>
    $('a', @lineup).on
      mouseover: (e) => $(e.currentTarget).css color: @color()
      mouseout: (e) => $(e.currentTarget).css color: ''
    $(document).on('click', 'a.listen', @listen)
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
    container = $('#map-container')[0]
    return unless container
    pos = $('*[data-map-default]').data('map-marker')
    position = new LatLng(pos[0], pos[1])
    map = new Map container,
      center: latlng
      scrollwheel: no
      zoom: 15
      draggable: not Modernizr.touch
    marker = new Marker { position, map }

    $('*[data-map-marker]').each (i, a) =>
      $(a).click (e) =>
        e.preventDefault()
        pos = $(e.currentTarget).data('map-marker')
        latlng = new LatLng(pos[0], pos[1])
        marker.setPosition(latlng)
        map.panTo(latlng)
        $.smoothScroll scrollTarget: map.getDiv()

    $(window).resize => map.setCenter map.getCenter()

  ### Event Handlers ###

  show_band: (band) =>
    return @band.show() if $("##{band}").length > 0
    $('.container', @band).load "/band/#{band} .band", (html) =>
      document.title = $(html).filter('title').text()
      @band.fadeIn()

  hide_band: => @band.fadeOut()

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

  ### Helpers ###

  grab_title: (el) =>
    title = el.data 'title'
    str = @title
    str = "#{title} — #{str}" if title
    document.title = str

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