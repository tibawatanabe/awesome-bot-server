if process.argv.length < 3 and not process.argv[2]
  console.log 'Worker path was not provided'
else
  require('rootpath')()

  workerPath = process.argv[2]

  worker = require workerPath

  console.log "Starting to run job at '#{workerPath}'"

  worker.exec (err) ->
    if err
      console.log "Error running job at '#{workerPath}': #{err}"
      process.exit(1)
    else
      console.log "Finished running job at '#{workerPath}'"
      process.exit(0)
