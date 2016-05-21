app = {}
app.packageJson = require('../package.json')
app.express = require('express')
app.bodyParser = require('body-parser')
app.dataHandling = require('node-data-handling')()
app.jsonschema = require('jsonschema')
app.validator = new app.jsonschema.Validator()
app.configHelper = require('tq1-helpers').config_helper
app.passport = require('passport')
app.Strategy = require('passport-http-bearer').Strategy
app.jwt = require('jsonwebtoken')
app.crypto = require('crypto')
app._ = require('lodash')
app.qs = require('qs')

# Locale
locale = {}
locale.i18n = require('i18n')
locale.source = 'locales'

# Config
core = {}
core.config = require('src/core/config/config') app.configHelper, app.packageJson

# Helpers
core.helpers = {}
core.helpers.auth = require('src/core/helpers/auth') core.config, app.crypto

# Logs
require('tq1-logger')(core.config.loggerOptions, console)

# Common Module
common = {}
common.jsonSchemaValidator = require('src/modules/common/json-schema-validator') app.validator

# Http Module
core.http = {}
core.http.mixin = require('src/core/http/mixin.coffee')()
core.http.responseBuilder = require('src/core/http/response-builder.coffee') common.jsonSchemaValidator
core.http.responseMessage = require('src/core/http/response-message.coffee')()

# Database
db = {}
db.schemas = {}
db.schemas.user = require('src/db/schemas/user') app.dataHandling.Schema
db.db = require('src/db/db') app.dataHandling.Model, db.schemas

# Common middlewares
common.middlewares = {}
common.middlewares.mobileRequestValidator = require('src/modules/common/middlewares/mobile-request-validator-middleware') core.http.responseBuilder, common.jsonSchemaValidator
common.middlewares.authenticationMiddleware = require('src/modules/common/middlewares/authentication-middleware') core.http, core.config, app.passport, app.Strategy, app.jwt, db.db
common.middlewares.paginatedRequest = require('src/modules/common/middlewares/paginated-request-middleware') app._, app.qs

# Account
account = {}
account.schemas = {}
account.schemas.loginRequest = require('src/modules/account/login/login-mobile-request-schema.json')
account.controllers = {}
account.controllers.login = require('src/modules/account/login/login-controller') core.http, db.db, common.middlewares, core.helpers.auth

# Routes
routes = {}
routes.routes = require('src/routes/routes') app.express, core.config, routes
routes.v1 = {}
routes.v1.account = require('src/modules/account/account-router-v1') account, common.middlewares

module.exports =
  app: (callback) -> require('src/app') app.express, app.bodyParser, core.config, routes.routes, locale, callback
  db: db.db
  common: common
