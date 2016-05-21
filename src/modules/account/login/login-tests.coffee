module.exports = (dependencies) ->
  async = dependencies.async
  server = dependencies.server
  assert = dependencies.assert
  done = dependencies.done

  describe 'Login Endpoint', () ->
    header = {}
    body = {}
    userObj = {}

    before (done) ->
      header = {}

      userObj = 
        name: "User"
        email: "user@email.com"
        password: "password"

      user = new server.db().User(userObj)
      user.save(done)

    beforeEach () ->
      body =
        email: "user@email.com"
        password: "password"

    after (done) ->
      server.db().User.remove({}, done)

    it 'should return HTTP 200 for success on login', (done) ->
      server.request 'POST', '/v1/login', body, header, (res, responseBody) ->
        assert.isObject responseBody.data
        assert.isDefined responseBody.data.token
        assert.equal responseBody.data.name, userObj.name
        assert.match responseBody.data.message, /successfully/
        assert.equal res.statusCode, 200
        done()

    it 'should return HTTP 200 for success on login with localized message', (done) ->
      header =
        'Accept-Language': 'pt'
      server.request 'POST', '/v1/login', body, header, (res, responseBody) ->
        assert.equal res.statusCode, 200
        assert.match responseBody.data.message, /sucesso/

        done()

    it 'should return HTTP 401 for invalid password on login', (done) ->
      body.password = "abcdef"
      server.request 'POST', '/v1/login', body, header, (res, responseBody) ->
        assert.equal res.statusCode, 401
        done()

    it 'should return HTTP 400 for login with no body', (done) ->
      server.request 'POST', '/v1/login', null, header, (res, responseBody) ->
        assert.equal res.statusCode, 400
        done()
