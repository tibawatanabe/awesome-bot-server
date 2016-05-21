# awesome-bot-server - Node.js - API Server

## Environment setup

This is what do you need to run this project locally:

1. Install and setup a Docker environment (Engine + Compose) following [these instructions](https://docs.docker.com/compose/install/)

2. Install [Node.js](https://nodejs.org/en/download/releases/)

  **Suggestion**: install [nvm](https://github.com/creationix/nvm) (Node Version Manager) and then install node v0.12.7 by running
  ```
  $ nvm install 0.12.7
  ```

3. If everything is installed correctly you can run this to start docker images from this project root
  ```
  $ docker-compose up
  ```

  It'll create and start containers for each item on [docker-compose](docker-compose.yml) file

  Add the flag `-d` to this command to run it in backgroud. To stop the services run
  ```
  $ docker-compose stop
  ```
  
  **Tip**: Check if Docker default VM is running
  ```
  $ docker-machine ls
  ```
  
  If not, start it
  ```
  $ docker-machine start default
  ```
  
  If `$ docker-compose up` is returning this error ```Couldn't connect to Docker daemon - you might need to run `docker-machine start default```` try this (tip from [here](https://github.com/docker/compose/issues/2180))
  ```
  $ eval $(docker-machine env default)
  ```

## Running this project

1. Install all dependencies by running the following command on project root
  ```
  $ npm install
  ```

2. Create an `.env` file with all environment variables needed. You can base the file on [`.env.sample`](.env.sample) as an example

3. Run this to start server
  ```
  $ npm run start
  ```

## Running this project - workers

1. Install all dependencies by running the following command on project root
  ```
  $ npm install
  ```

2. Create an `.env` file with all environment variables needed. You can base the file on [`.env.sample`](.env.sample) as an example

3. If you don't know the task name, check `package.json` for `worker-*` tasks

3. Run task
  ```
  $ npm run worker-example
  ```

## Development

### Adding background workers
 
1. Each worker has its own folder with the file structure located at `src/worker/<worker-name>`

  1. `index.coffee` - is the file loaded and should handle all dependencies, which should export an object with `db` (with a database index, for testing purposes) and an `exec` function with a callback param, which will be the function used to start the job.

  2. If tests are to be added, they will follow the default structure and should have file names ending in `tests.coffee`

2. Add a worker line to `Procfile` with the syntax `<worker name>: coffee src/worker-runner.coffee src/workers/<worker folder name>`

3. Add a script entry to `package.json`'s `scripts` hash with `nf start <worker name at Procfile>`

4. To run, execute `$ npm run <package.json scripts hash key for worker>`


## Test

```
$ npm install
$ npm test
```

### caveat

Travis build will execute `$ npm run travis`, so environment variables can be used exclusively for CI, depending on the needs

### npm shrinkwrap

To shrinkwrap an existing package:

1. Run npm install in the package root to install the current versions of all dependencies.
*  Validate that the package works as expected with these versions.
*  Run npm shrinkwrap, add npm-shrinkwrap.json to git, and publish your package.

To add or update a dependency in a shrinkwrapped package:
1. Run npm install in the package root to install the current versions of all dependencies.
* Add or update dependencies. npm install --save each new or updated package individually to update the package.json and the shrinkwrap. Note that they must be explicitly named in order to be installed: running npm install with no arguments will merely reproduce the existing shrinkwrap.
* Validate that the package works as expected with the new dependencies.
* Commit the new npm-shrinkwrap.json, and publish your package.

You can use [npm-outdated](https://docs.npmjs.com/cli/outdated) to view dependencies with newer versions available.

**Reference**: [npm-shrinkwrap](https://docs.npmjs.com/cli/shrinkwrap) documentation.
