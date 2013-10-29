{ findWhere } = require 'underscore'
nconf = require 'nconf'

title = "All My Friends 2013"

module.exports = (app) ->

  index = (req, res) -> res.render 'home/index', { title }

  app.get '/', index
  app.get '/lineup', index
  app.get '/festival', index
  app.get '/partners', index
  app.get '/location', index

  app.get '/band/:band', (req, res, next) ->
    band = findWhere app.locals.bands, slug: req.params.band
    return do next unless band
    res.render 'home/band', { band, initial: yes, title: "#{band.name} — #{title}" }
