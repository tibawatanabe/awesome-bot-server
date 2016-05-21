module.exports = (module, middlewares) ->

  controllers = module.controllers
  schemas = module.schemas

  return (router) ->
    router.get '/devices',
      (req, res) ->
        controllers.list.exec (response) ->
          return response.send(res)

    router.post '/devices',
      middlewares.mobileRequestValidator schemas.create, 'body'
      (req, res) ->
        controllers.create.exec req.body,
          (response) ->
            return response.send(res)

    router.get '/devices/:id',
      (req, res) ->
        controllers.detail.exec req.params.id,
          (response) ->
            return response.send(res)

    router.put '/devices/:id',
      middlewares.mobileRequestValidator schemas.edit, 'body'
      (req, res) ->
        controllers.edit.exec req.params.id, req.body,
          (response) ->
            return response.send(res)

    router.delete '/devices/:id',
      (req, res) ->
        controllers.delete.exec req.params.id,
          (response) ->
            return response.send(res)
