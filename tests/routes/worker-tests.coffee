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

# Config helpers
configHelper = require('tq1-helpers').config_helper
config = require('src/core/config/config') configHelper, packageJson

fileLoader = require('tests/utils/file-loader') walk

workerStub = require('tests/stubs/worker')

stubs =
  'tq1-logger': () ->
    return

workers = {}
workers.example = workerStub 'src/workers/example', stubs

describe 'Modules', () ->

  fileLoader.require 'src/workers', 'tests.coffee',
    async: async
    _: _
    assert: assert
    expect: expect
    sinon: sinon
    workers: workers