module.exports = (http, db) ->

  exec: (id, callback) ->
    db.Device.delete id, (err, count) ->
      if err
        return callback http.responseBuilder.build(
          http.responseMessage.DATABASE_ERROR,
          http.responseBuilder.ErrorType.DATABASE_ERROR
        )
      else
        return callback http.responseBuilder.build()
