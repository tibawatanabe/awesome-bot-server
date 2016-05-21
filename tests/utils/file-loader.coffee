module.exports = (walk) ->

  aggregateTestFiles = (splitFilesPath, path) ->
    # creating nested objects reflecting a path - i.e ```[ common, middlewares, paginated-request-middleware-tests.coffee ]```
    # results in:
    # ```
    # {
    #   "common": {
    #     "middlewares": {
    #       "src/modules/common/middlewares/paginated-request-middleware-tests": null
    #     }
    #   }
    # }
    # ```
    filesPathAsObject = {}

    for filePathAsArray in splitFilesPath

      pathArrayToObj = (pathArray, pathObj, path) ->
        if not pathArray or pathArray.length <= 1
          # last item from array, restoring full file path
          file = {}
          file[path + '/' + pathArray.shift().split('.')[0]] = null
          return file

        first = pathArray.shift()

        if Object.keys(pathObj).indexOf(first) < 0
          pathObj[first] = {}

        pathObj[first] = pathArrayToObj(pathArray, pathObj[first], path + '/' + first)

        return pathObj

      filesPathAsObject = pathArrayToObj(filePathAsArray, filesPathAsObject, path)
      
    return filesPathAsObject

  getFiles = (path, posfix) ->
    splitFilesPath = []
    options =
      followLinks: false
      listeners:
        file: (root, fileStats, next) ->
          # filtering files matching posfix and splitting the path (used later in recursiveDescribe() to create nested descriptions)
          name = fileStats.name
          if name.slice(0 - posfix.length) == posfix 
            # splitting full path (i.e ```common/middlewares/paginated-request-middleware-tests.coffee```
            # results in ```[ common, middlewares, paginated-request-middleware-tests.coffee ]```)
            splitFilesPath.push (root+'/'+name).replace(path + '/', '').split('/')
          next()

    walk.walkSync path, options
    return aggregateTestFiles splitFilesPath, path

  recursiveDescribe = (pathObj, dependencies) ->
    if typeof(pathObj) == "object" and Object.keys(pathObj)
      for key in Object.keys(pathObj)
        if pathObj[key]
          formatedKey = (key.split('-').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
          describe formatedKey, () ->
            recursiveDescribe pathObj[key], dependencies
        else
          require(key) dependencies

  loader =
    require: (path, posfix, dependencies) ->
      files = getFiles path, posfix
      return recursiveDescribe files, dependencies

  return loader