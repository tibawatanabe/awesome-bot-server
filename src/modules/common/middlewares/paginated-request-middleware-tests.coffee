module.exports = (dependencies) ->
  async = dependencies.async
  server = dependencies.server
  assert = dependencies.assert
  _ = dependencies._
  qs = dependencies.qs

  paginatedRequest = null

  describe 'Middleware - Paginated Request', () ->
    req = null

    before () ->
      paginatedRequest = server.middlewares().paginatedRequest

    beforeEach () ->
      req =
        paging:
          pageSize: 22
          pageNumber: 3
        originalUrl: "http://google.com?pageSize=22&pageNumber=3"
        query:
          pageSize: 22
          pageNumber: 3


    describe 'Middleware', () ->

      beforeEach () ->
        delete req.paging

      it 'should populate request with a "paging" object', (done) ->
        paginatedRequest.middleware req, null, () ->
          assert.lengthOf arguments, 0

          assert.isObject req.paging
          assert.equal req.paging.pageSize, req.query.pageSize
          assert.equal req.paging.pageNumber, req.query.pageNumber

          done()

      it 'should populate request with a default pageSize value when query does not provide it', (done) ->

        req.originalUrl = "http://google.com?&pageNumber=3"
        delete req.query.pageSize

        paginatedRequest.middleware req, null, () ->
          assert.lengthOf arguments, 0

          assert.isObject req.paging
          assert.equal req.paging.pageSize, 10
          assert.equal req.paging.pageNumber, req.query.pageNumber

          done()


      it 'should populate request with a default pageNumber value when query does not provide it', (done) ->

        req.originalUrl = "http://google.com?&pageSize=22"
        delete req.query.pageNumber

        paginatedRequest.middleware req, null, () ->
          assert.lengthOf arguments, 0

          assert.isObject req.paging
          assert.equal req.paging.pageSize, req.query.pageSize
          assert.equal req.paging.pageNumber, 1

          done()

      it 'should populate request with a default paging object value when query does not provide any', (done) ->

        req.originalUrl = "http://google.com"
        req.query = {}

        paginatedRequest.middleware req, null, () ->
          assert.lengthOf arguments, 0

          assert.isObject req.paging
          assert.equal req.paging.pageSize, 10
          assert.equal req.paging.pageNumber, 1

          done()

    describe 'IsLastPage', () ->

      data = null

      beforeEach (done) ->
        data = []

        async.times 10, (n, next) ->
          data.push ["any data #{n}"]
          next()
        , done

      it 'should return false if data length is bigger than pageSize', () ->
        req.paging.pageSize = 5
        assert.isFalse paginatedRequest.isLastPage(req.paging.pageSize, data)

      it 'should return false if data length is equal pageSize', () ->
        req.paging.pageSize = 10
        assert.isFalse paginatedRequest.isLastPage(req.paging.pageSize, data)

      it 'should return true if data length is smaller than pageSize', () ->
        req.paging.pageSize = 100
        assert.isTrue paginatedRequest.isLastPage(req.paging.pageSize, data)

      it 'should return true if data is not provided', () ->
        assert.isTrue paginatedRequest.isLastPage(req.paging.pageSize)

      it 'should return true if pagination is not provided on request', () ->
        assert.isTrue paginatedRequest.isLastPage(null)

    describe 'LastPage URL', () ->

      it 'should return pagination params on next page URL', () ->
        # parses url params into object for better value checking
        params = qs.parse(paginatedRequest.nextPage(req.paging, req.query))
        assert.equal params.pageSize, req.paging.pageSize
        assert.equal params.pageNumber, req.paging.pageNumber + 1

      it 'should return pagination params + other query params on next page URL', () ->
        req.originalUrl = "http://google.com?pageSize=10&pageNumber=3&filter=filtertest"
        req.query =
          pageSize: 10
          pageNumber: 3
          filter: "filtertest"
        # parses url params into object for better value checking
        params = qs.parse(paginatedRequest.nextPage(req.paging, req.query))
        assert.equal params.pageSize, req.paging.pageSize
        assert.equal params.pageNumber, req.paging.pageNumber + 1
        assert.equal params.filter, req.query.filter