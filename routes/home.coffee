module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'home/index', title: 'All My Friends'

  app.get '/d', (req, res) ->
    res.send new(Date).toDateString()