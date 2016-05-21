# This module loads test classes with stubs if needed

require('rootpath')()
proxyquire = require('proxyquire')

app_worker = (path, stubs) ->
  worker = null

  try
    if not worker
      if stubs
        worker = proxyquire(path, stubs)
      else
        worker = require(path)
  catch error
    throw error

  worker: worker

module.exports = app_worker