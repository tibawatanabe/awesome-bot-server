require('rootpath')()
proxyquire = require('proxyquire')
querystring = require('querystring')
http = require('http')
_ = require('lodash')
async = require('async')

port = process.env.PORT
app = null
server = null
stubs = {}

defaultHttpOptions = (method, path, body = null, headers = {}) ->

  newHeaders = _.assign 'Content-Type': 'application/json', headers

  options =
    'host': 'localhost'
    'port': port
    'path': path
    'method': method
    'headers': newHeaders

  return options

app_server =

  stubs: (obj) ->
    stubs = obj

  createUserAndLogin: (data, shouldRemove, callback) ->
    body = _.defaults data,
      name: "User"
      email: "user@email.com"
      password: "password"

    async.series
      remove: (cb) ->
        if shouldRemove
          # clean up user database
          server.db.User.remove {}, cb
        else
          cb()

      new: (cb) ->
        user = new server.db.User body
        user.save cb

      login: (cb) ->
        auth_body = 
          email: body.email
          password: body.password

        app_server.request 'POST', '/v1/login', auth_body, {}, (res, responseBody) ->
          unless res.statusCode is 200
            cb "Error logging in user"

          header = 
            "Authorization": responseBody.data.token

          cb null,
            header: header

      , (err, results) ->
        callback err,
          header: results?.login?.header
          user: results?.new[0]

  start: (callback) ->
    if not server
      if stubs
        server = proxyquire 'src/server', stubs
      else
        server = require 'src/server'

      app = server.app (err) ->
        return callback err if err
        return callback() if not err

  stop: (callback) ->
    app.close () ->
      callback()

  request: (method, path, body, headers = {}, callback) ->
    responseBody = ""
    body_json = JSON.stringify body if body

    req = http.request defaultHttpOptions(method, path, body_json, headers), (res) ->
      responseData = ""
      res.on "data", (chunk) ->
        responseData += chunk.toString()
      res.on "end", () ->
        data = null
        try
          data = JSON.parse responseData
        catch error
          console.log "[StubApp] Err: #{error}"
        callback res, data if callback?
        
    req.write body_json if body
    req.end()

  db: () ->
    return server.db

  middlewares: () ->
    return server.common.middlewares

module.exports = app_server
