module.exports = (robot) ->
  robot.hear /hello/, (msg) ->
      msg.send 'hello back'
  robot.respond /foo/, (msg) ->
      msg.reply 'bar'
