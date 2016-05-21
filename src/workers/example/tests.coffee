module.exports = (dependencies) ->
  assert  = dependencies.assert
  sinon   = dependencies.sinon
  async   = dependencies.async
  wrapper = dependencies.workers.example
  worker  = wrapper.worker

  describe 'Worker - Example', () ->

    it 'should call logger module', (done) ->
      spy = null
      async.series [
        (cb) ->
          spy = sinon.spy worker.job, 'log'
          worker.exec cb
        (cb) ->
          assert.equal spy.callCount, 1
          spy.restore()
          cb()
      ], done