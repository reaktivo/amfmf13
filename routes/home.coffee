
band_css_template = """
  .SLUG.band { background-image: url(/bands/1024/SLUG.jpg) }
  @media only screen and (max-width: 640px) {
    .SLUG.band { background-image: url(/bands/640/SLUG.jpg) }
  }
  #SLUG .SLUG.band .text {
    display: block;
    color: COLOR;
  }

"""

module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'home/index', title: 'All My Friends 2013'

  app.get '/bands.css', (req, res) ->
    res.type 'css'
    for band in app.locals.bands
      res.write band_css_template
        .replace(/SLUG/g, band.slug)
        .replace(/COLOR/g, band.color)
    do res.end
