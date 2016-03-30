{expect} = require 'chai'
{join} = require 'path'
humock = require '../humock.coffee'

describe 'humock', ->

  describe 'start', ->

    it 'initializes humock', (done)->
      humock.start ->
        expect(humock.getRobot()).to.be.ok;
        expect(humock.getUser()).to.be.ok;
        expect(humock.getAdapter()).to.be.ok;
        humock.shutdown()
        done()

  describe 'learn', ->

    it 'adds a listener using module', (done) ->
      humock.start ->
        robot = humock.getRobot()
        originalNumber = robot.listeners.length
        humock.learn require './hello-script.coffee'
        expect(robot.listeners.length).not.equal(originalNumber)
        humock.shutdown()
        done()

    it 'adds a listener using absolute path', (done) ->
      humock.start ->
        robot = humock.getRobot()
        originalNumber = robot.listeners.length
        humock.learn join(__dirname, 'hello-script.coffee')
        expect(robot.listeners.length).not.equal(originalNumber)
        humock.shutdown()
        done()

  describe 'test', ->

    beforeEach (done) ->
      humock.start ->
        humock.learn require './hello-script.coffee'
        done()

    afterEach (done) ->
      humock.shutdown -> done()

    it 'provides callback-based way of testing send', (done) ->
      humock.test 'hello', (envelope, strings) ->
        expect(strings[0]).match /hello back/
        done()

    it 'provides promise-based way of testing send', (done) ->
      humock.test('hello').then (response) ->
        expect(response.toString()).match /hello back/
        done()

    it 'provides callback-based way of testing reply', (done) ->
      humock.test 'hubot: foo', (envelope, strings) ->
        expect(strings[0]).match /bar/
        done()

    it 'provides promise-based way of testing reply', (done) ->
      humock.test('hubot: foo').then (response) ->
        expect(response.toString()).match /bar/
        done()

  describe 'shutdown', ->

    it 'shuts down humock', (done) ->
      humock.start ->
        humock.shutdown ->
          expect(humock.getRobot()).to.be.not.ok;
          expect(humock.getUser()).to.be.not.ok;
          expect(humock.getAdapter()).to.be.not.ok;
          done()
