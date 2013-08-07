module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'home/index', title: 'All My Friends'