module.exports = (http, db, _) ->

  exec: (callback) ->
    db.Device.find {}, (err, devices) ->
      if err
        return callback http.responseBuilder.build(
          http.responseMessage.DATABASE_ERROR,
          http.responseBuilder.ErrorType.DATABASE_ERROR
        )
      else
        list = _.map devices, (device) ->
          id: device._id,
          model: device.model
          os: device.os,
          version: device.version,
          notes: device.notes,
          owner: device.owner,
          status: device.status,
          date: device.date,
          user: device.user
        return callback http.responseBuilder.build list
