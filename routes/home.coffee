
reveal = new Date("Thu, 08 Aug 2013 10:00:00 GMT-0700")

module.exports = (app) ->

  app.get '/', (req, res) ->
    countdown = (reveal - new Date) / 1000 / 60

    if countdown < 0 or req.query.show
      res.render 'home/index', title: 'All My Friends 2013'
    else
      res.render 'home/black', { countdown }