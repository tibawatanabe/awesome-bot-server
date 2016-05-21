worker = {}
worker.packageJson = require('../../../package.json')
worker._ = require('lodash')
worker.async = require('async')
worker.configHelper = require('tq1-helpers').config_helper
worker.dataHandling = require('node-data-handling')()

# Config
core = {}
core.config = require('src/core/config/config') worker.configHelper, worker.packageJson

# Logs
require('tq1-logger')(core.config.loggerOptions, console)

# Database
db = {}
db.schemas = {}
db.schemas.user = require('src/db/schemas/user') worker.dataHandling.Schema
db.schemas.device = require('src/db/schemas/device') worker.dataHandling.Schema
db.db = require('src/db/db') worker.dataHandling.Model, db.schemas

job = require('src/workers/example/job')(core.config, db.db)

module.exports =
  db: db.db
  job: job
  exec: (callback) ->
    job.exec(callback)
