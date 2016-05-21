module.exports = (http, db, middlewares, auth) ->
  searchUser = (email, callback) ->
    db.User.findOne(
      email: email
    ).exec(callback)

  validatePassword = (user, password) ->
    return user?.password == auth.hash(password)

  responseObject = (message, user, token) ->
    token: token
    message: message
    name: user.name

  userToken = (user) ->
    return middlewares.authenticationMiddleware.generateToken
      usr: user._id

  exec: (params, callback) ->
    searchUser params.data.email, (err, user) ->
      if err?
        return callback http.responseBuilder.build(params.locale('app.error.database'), http.responseBuilder.ErrorType.DATABASE_ERROR)
      else
        if user? and validatePassword(user, params.data.password)
          return callback http.responseBuilder.build(responseObject(params.locale('login.message.ok'), user, userToken(user)))
        else
          return callback http.responseBuilder.build(params.locale('login.error.invalid'), http.responseBuilder.ErrorType.UNAUTHORIZED_ERROR)
