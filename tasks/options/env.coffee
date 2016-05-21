grunt = require('grunt')

# add environment variables common to all here, if needed
baseEnvironment =

  NODE_ENV: 'test'
  PORT: 3000
  LOGGER_LEVEL: 'DEBUG'

  MEMCACHE_USERNAME: 'admin'
  MEMCACHE_PASSWORD: 'admin'

  JWT_SECRET: 'secret'
  DEFAULT_SALT: 'secret'

# add local test environment variables here, if needed
#  values added here will overwrite the ones from 'baseEnvironment'
testEnvironment = grunt.util._.extend grunt.util._.clone(baseEnvironment),

  MONGODB_URL: '192.168.99.100:27017/test'
  MEMCACHE_SERVERS: '192.168.99.100:11211/test'

# add travis test environment variables here, if needed
#  values added here will overwrite the ones from 'baseEnvironment'
travisEnvironment = grunt.util._.extend grunt.util._.clone(baseEnvironment),

  MONGODB_URL: '127.0.0.1:27017/test'
  MEMCACHE_SERVERS: '127.0.0.1:11211/test'

module.exports =
  travis: travisEnvironment
  test: testEnvironment
