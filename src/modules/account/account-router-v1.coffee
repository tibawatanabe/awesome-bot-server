module.exports = (module, middlewares, passport) ->
  validationMiddleware = middlewares.mobileRequestValidator

  controllers = module.controllers
  schemas = module.schemas

  return (router) ->
    router.post '/login', validationMiddleware(schemas.loginRequest, 'body'), (req, res) ->
      controllers.login.exec
        locale: res.__
        data: req.body
      , (response) ->
        return response.send(res)
