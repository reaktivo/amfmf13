process.chdir __dirname
express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
load = require 'express-load'
nconf = require 'nconf'
jsyaml = require 'js-yaml'
redirect = require './redirect'
{ join } = require 'path'

module.exports = app = express()
app.set 'port', process.env.PORT or 3000
app.set 'views', "views"
app.set 'view engine', 'jade'
app.set 'title', "AMFMF"
app.use redirect()
app.use express.favicon('assets/img/favicon.png')
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use assets()
app.use '/bands', express.static 'bands'
app.use express.static "assets"

load('locals', extlist:['.yml']).into(app)
load('routes').into(app)

app.configure 'development', ->
  app.use express.errorHandler()

app.listen app.get('port')
console.log "Express server listening on port #{app.get('port')}"

