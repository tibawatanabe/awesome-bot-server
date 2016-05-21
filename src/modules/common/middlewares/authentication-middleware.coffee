module.exports = (http, config, passport, Strategy, jwt, db) ->
  passport.use(new Strategy { passReqToCallback: true }, (req, token, done) ->
    jwt.verify(token, config.security.jwtSecret, (err, decoded) ->
      errorMessage = http.responseBuilder.build(req.res.__('app.error.unauthorized'), http.responseBuilder.ErrorType.UNAUTHORIZED_ERROR)
      if err? or !decoded.usr
        return errorMessage.send req.res
      db.User.findLeanById(decoded.usr, (err, user) ->
        if err? or !user
          return errorMessage.send req.res
        return done null, user
      )
    )
  )

  authenticate: (strategy) ->
    passport.authenticate(strategy, { session: false })

  generateToken: (payload) ->
    jwtToken = jwt.sign(payload, config.security.jwtSecret)
    return "Bearer " + jwtToken
