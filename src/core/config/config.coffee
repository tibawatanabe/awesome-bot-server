module.exports = (configHelper, packageJson) ->

  result =
    api:
      port: process.env.PORT || 80
      defaultSalt: process.env.DEFAULT_SALT || ""

    loggerOptions:
      log_level: process.env.LOGGER_LEVEL
      name: packageJson.name

    security:
      jwtSecret: process.env.JWT_SECRET

    validate: () ->
      configHelper.outputConfigValue result, "api.port", true
      configHelper.outputConfigValue result, "loggerOptions.log_level", true
      configHelper.outputConfigValue result, "loggerOptions.name", true

  return result
