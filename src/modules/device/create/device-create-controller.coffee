module.exports = (http, db) ->

  exec: (data, callback) ->
    db.Device.saveOrUpdate null,
      model: data.model
      version: data.version
      notes: data.notes
      owner: data.owner
      status: data.status
      date: data.date
      user: data.user
    , (err, device) ->
      if err
        return callback http.responseBuilder.build(
          http.responseMessage.DATABASE_ERROR,
          http.responseBuilder.ErrorType.DATABASE_ERROR
        )
      else
        return callback http.responseBuilder.build
          id: device.upserted[0]._id
          model: data.model
          version: data.version
          notes: data.notes
          owner: data.owner
          status: data.status
          date: data.date
          user: data.user
