do (jQuery, window) ->

  $ = jQuery

  $.fn.iphone = (options) ->

    if @data('iphone')
      @data('iphone', 'active')
      return this

    options = $.extend
      time: 3000
    , options

    screen = $('.screen', this)
    container = $('.images', screen)
    images = $('img', container)
    width = screen.width()
    position = -1

    $('img', screen).each (i) ->
      $(this).css left: width * i

    do next = ->
      position += 1
      container.animate left: - width * position
      if position >= images.length - 1
        position = -1
      setTimeout next, options.time

    this

  $(document).ready -> do $('.iphone').iphone
