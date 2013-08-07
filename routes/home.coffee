
reveal = new Date("2013-08-08T07:00:00.000Z")

module.exports = (app) ->

  app.get '/', (req, res) ->
    countdown = (reveal - new Date) / 1000 / 60
    if countdown < 0 or req.query.show
      res.render 'home/index', title: 'All My Friends 2013'
    else
      res.render 'home/black', { countdown }