{ findWhere } = require 'underscore'

title = "All My Friends 2013"
prefix = ""
if process.env.NODE_ENV is "production"
  prefix = "//media.amfmf.com"

band_css_template = """
  .SLUG.band { background-image: url(#{prefix}/bands/landscape/SLUG.jpg) }
  @media only screen and (orientation: portrait) {
    .SLUG.band { background-image: url(#{prefix}/bands/portrait/SLUG.jpg) }
  }

"""

module.exports = (app) ->

  index = (req, res) -> res.render 'home/index', { title }

  app.get '/', index
  app.get '/lineup', index

  app.get '/band/:band', (req, res) ->
    band = findWhere app.locals.bands, slug: req.params.band
    if band
      res.render 'home/index', { title }
    else
      res.redirect '/'

  app.get '/bands.css', (req, res) ->
    res.type 'css'
    for band in app.locals.bands
      res.write band_css_template
        .replace(/SLUG/g, band.slug)
        .replace(/INVERSE/g, band.inverse)
        .replace(/COLOR/g, band.color)
    do res.end
