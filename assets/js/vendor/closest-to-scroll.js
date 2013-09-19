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

  function throttle(fn, threshhold, scope) {
    threshhold || (threshhold = 250);
    var last,
        deferTimer;
    return function () {
      var context = scope || this;

      var now = +new Date,
          args = arguments;
      if (last && now < last + threshhold) {
        // hold on to it
        clearTimeout(deferTimer);
        deferTimer = setTimeout(function () {
          last = now;
          fn.apply(context, args);
        }, threshhold);
      } else {
        last = now;
      }
    };
  }

  $.fn.closestToScroll = function(options, fn) {

    if (typeof(options) === "function") {
      fn = options;
      options = {};
    }

    options = $.extend({
      maxDistance: 200,
      threshhold: 500
    }, options)

    var self = this, $window = $(window)

    var fn = throttle(fn, options.threshhold)

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
