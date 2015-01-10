Mock-hubot
==========
This is a simple wrapper library around [hubot-mock-adapter](https://github.com/blalor/hubot-mock-adapter).

###How to use
`$ npm install --save-dev mock-hubot`

 [Assume we were to test this script.](test/hello-script.coffee)

```
humock = require 'mock-hubot'
helloScript = require './hello-script.coffee'
{expect} = require 'chai'

describe 'test', ->

    beforeEach (done) ->
      humock.start ->
        humock.learn helloScript
        done()

    afterEach (done) ->
      humock.shutdown -> done()

    it 'provides callback-based way of testing', (done) ->
      humock.test 'hello', (envelope, strings) ->
        expect(strings[0]).match /hello back/
        done()

    it 'provides promise-based way of testing', (done) ->
      humock.test('hello').then (response) ->
        expect(response.toString()).match /hello back/
        done()

```
