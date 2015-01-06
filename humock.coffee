Robot = require 'hubot/src/robot'
{TextMessage} = require 'hubot/src/message'
Q = require 'q'
{robot, user, adapter} = {}

addScript = (script) ->
  strategies =
    'string': -> require(script)(robot)
    'function': -> script(robot)

  strategy = strategies[typeof script] or ->
    throw new Error 'Only a path/function or an array of either shall be past into start method.'

  strategy()

addScriptsWhichAreBeingTested = (scripts) ->
  if Array.isArray scripts
    scripts.forEach addScript
  else
    addScript scripts

testWithCallback = (message, callback) ->
  adapter.on 'send', callback
  adapter.receive new TextMessage(user, message)

testWithPromise = (message) ->
  Q.Promise (resolve) ->
    adapter.on 'send', (envelope, strings) ->
      resolve {
        envelope,
        strings,
        toString: -> strings[0]
      }
    adapter.receive new TextMessage(user, message)

module.exports =
  getUser: -> user
  getAdapter: -> adapter
  getRobot: -> robot

  start: (callback) ->
    if !callback
      console.warn 'Create method is asynchronous. Please provide a callback to notify your testing framework when you are done.'
    robot = new Robot null, 'mock-adapter', false, 'hubot'
    robot.adapter.on 'connected', ->
      user = robot.brain.userForId '1', {
        name: 'mocha',
        room: '#mocha'
      }
      adapter = robot.adapter
      callback()
    robot.run()

  learn: (scripts) ->
    addScriptsWhichAreBeingTested scripts

  test: (message, callback) ->
    if callback
      if !/done/.test callback.toString()
        console.warn 'Test method is asynchronous. Please notify your testing framework when you are done.'
      testWithCallback message, callback
    else
      testWithPromise message

  shutdown: (callback) ->
    robot.shutdown()
    {robot, user, adapter} = {}
    if callback
      callback()
