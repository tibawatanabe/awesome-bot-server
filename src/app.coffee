module.exports = (express, bodyparser, config, router, locale, callback) ->

  config.validate()

  app = express()
  app.disable('x-powered-by') # https://speakerdeck.com/ckarande/top-overlooked-security-threats-to-node-dot-js-web-applications?slide=57

  app.use bodyparser.json() # for parsing application/json

  locale.i18n.configure
    locales: ['en', 'pt']
    defaultLocale: 'en'
    directory: "#{__dirname}/#{locale.source}"
    # api:
      # '__': 't',  # now res.__ becomes res.t
      # '__n': 'tn' # and res.__n can be called as res.tn
  app.use locale.i18n.init

  # Route requests
  router app

  app.use (err, req, res, next) ->
    if err
      console.error "[app][error]" + err.stack
    next(err)

  return app.listen config.api.port, callback
