express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
load = require 'express-load'
nconf = require 'nconf'
jsyaml = require 'js-yaml'
{ join } = require 'path'

nconf.env().file(file: 'config.json')

module.exports = app = express()
app.set 'root', __dirname
app.set 'port', nconf.get('PORT') or 3000
app.set 'views', join __dirname, "views"
app.set 'view engine', 'jade'
app.set 'title', ""
app.use express.favicon('assets/img/favicon.png')
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use assets()
app.use '/bands', express.static join __dirname, 'bands'
app.use express.static join __dirname, "assets"

load('locals', extlist:['.yml']).into(app)
load('routes').into(app)

app.configure 'development', ->
  app.use express.errorHandler()

app.listen app.get('port')
console.log "Express server listening on port #{app.get('port')}"