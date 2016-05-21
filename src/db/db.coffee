module.exports = (dataHandling, schemas) ->

  User: dataHandling.model(schemas.user, 'user')
  Device: dataHandling.model(schemas.device, 'device')
