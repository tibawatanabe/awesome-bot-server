module.exports = (config, crypto) ->
  hash: (value) ->
    return crypto.createHash('sha1').update(config.api.defaultSalt + value).digest('base64')
