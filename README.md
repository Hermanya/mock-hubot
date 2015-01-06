Mock-hubot
==========
This is a simple wrapper library around [hubot-mock-adapter](https://github.com/blalor/hubot-mock-adapter).

###How to use

 [Assume we were to test this script.](test/hello-script.coffee)

```
describe 'test', ->

    beforeEach (done) ->
      humock.start ->
        humock.learn require './hello-script.coffee'
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
