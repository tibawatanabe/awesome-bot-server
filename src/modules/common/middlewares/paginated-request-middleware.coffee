module.exports = (_, qs) ->

  isLastPage: (pageSize, data) ->
    return true if not data?.length? or not pageSize?
    return (data.length < pageSize)

  nextPage: (paging, query) ->
    params = _.defaults
      pageNumber: paging.pageNumber + 1
      pageSize: paging.pageSize
    , query

    return qs.stringify params

  middleware: (req, res, next)  ->
    req.paging =
      pageSize: 10
      pageNumber: 1

    req.paging.pageSize = parseInt(req.query.pageSize) if req?.query?.pageSize? > 0
    req.paging.pageNumber = parseInt(req.query.pageNumber) if req?.query?.pageNumber? > 0

    next()