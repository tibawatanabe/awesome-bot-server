require('rootpath')()
_ = require('lodash')
chai = require('chai')
expect = chai.expect
assert = chai.assert
sinon = require('sinon')
sinonChai = require("sinon-chai");
chai.use sinonChai
walk = require('walk')
packageJson = require('package.json')
async = require('async')
qs = require('qs')

# Config helpers
configHelper = require('tq1-helpers').config_helper
config = require('src/core/config/config') configHelper, packageJson

fileLoader = require('tests/utils/file-loader') walk

server = require('tests/stubs/app-server')

stubs =
  'tq1-logger': () ->
    return

  'src/core/helpers/auth': () ->
    hash: (v) ->
      return v

before (done) ->
  server.stubs stubs
  server.start (err) ->
    console.log "\n\nTesting app modules...\n"
    done err

after (done) ->
  server.stop () ->
    done()

describe 'Modules', () ->

  fileLoader.require 'src/modules', '-tests.coffee',
    async: async
    _: _
    server: server
    assert: assert
    expect: expect
    qs: qs