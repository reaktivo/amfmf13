/*
 * closest-to-scroll.js - v1.0.0 - 2013-04-27
 * Marcel Miranda < reaktivo.com >
 * Copyright (c) 2013; Licensed MIT

  closestToScroll is a jQuery plugin that listens
  to the window's scroll event and calls the passed
  in function with the closest element selected as
  an argument.

  Usage:

  // when dom ready
  jQuery(document).ready(function($) {

    $('.post').closestToScroll(function(el) {
      // do something with the post which
      // is closest to the top.
    })

  })

*/


;(function($, window, document, undefined) {

  $.fn.closestToScroll = function(fn, options) {

    options = $.extend({
      maxDistance: 200
    }, options)

    var self = this, $window = $(window)

    $window.scroll(function() {

      var distance, closest = null;

      self.each(function() {
        var el = $(this)
        var elDistance = Math.abs(el.offset().top - $window.scrollTop())
        if (elDistance < distance || distance === undefined) {
          closest = el;
          distance = elDistance;
        }
      })

      if (closest && distance < options.maxDistance) fn(closest);

    })

    return this

  }

})(jQuery, window, document);
