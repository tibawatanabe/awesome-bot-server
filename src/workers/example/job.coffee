module.exports = (config, db) ->

  config.validate()

  worker =
    exec: (callback) ->

      worker.log()
      callback() if callback

    log: () ->
      console.log 'EXAMPLE WORKER WORKS!'

  return worker