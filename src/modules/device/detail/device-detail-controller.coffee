module.exports = (http, db) ->

  exec: (id, callback) ->
    db.Device.findById id, (err, device) ->
      if err
        return callback http.responseBuilder.build(
          http.responseMessage.DATABASE_ERROR,
          http.responseBuilder.ErrorType.DATABASE_ERROR
        )
      else if !device
        return callback http.responseBuilder.build(
          http.responseMessage.DEVICE_NOT_FOUND,
          http.responseBuilder.ErrorType.NOT_FOUND
        )
      else
        return callback http.responseBuilder.build
          id: device._id,
          model: device.model
          os: device.os,
          version: device.version,
          notes: device.notes,
          owner: device.owner,
          status: device.status,
          date: device.date,
          user: device.user
