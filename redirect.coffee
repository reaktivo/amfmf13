{ parse, format } = require 'url'

# options.add = false to send www.example.com -> example.com

module.exports = (options = {})

  options.prefix or= 'www'
  options.add = yes if options.add is undefined

  (req, res, next) ->

    host = req.host
    return do next if host is 'localhost'
    url = parse req.url

    if options.add
      if host.indexOf options.prefix is 0
        return do next
      else
        host = "#{options.prefix}.#{host}"
    else
      if host.indexOf options.prefix is 0
        host = host.substr options.prefix.length + 1
      else
        return do next()

    url.host = "www.#{host}"
    res.redirect format url