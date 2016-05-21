module.exports = (http, db) ->

  exec: (id, data, callback) ->
    db.Device.update { _id: id }, data,
      (err, data) ->
        if err
          return callback http.responseBuilder.build(
            http.responseMessage.DATABASE_ERROR,
            http.responseBuilder.ErrorType.DATABASE_ERROR
          )
        else if data.n == 0
          return callback http.responseBuilder.build(
            http.responseMessage.DEVICE_NOT_FOUND,
            http.responseBuilder.ErrorType.NOT_FOUND
          )
        else
          return callback http.responseBuilder.build()
