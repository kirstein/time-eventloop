chalk = require 'chalk'

intervalId = null
startTime  = null
tickTime   = 4

assign = (defaults, opts = {}) ->
  res = {}
  for key, val of defaults
    res[key] = opts[key] or val
  res

notifyDelay = (time) ->
  msg = chalk.yellow 'event loop delayed', time
  console.log msg

tick = (opts) ->
  delta = Date.now() - startTime
  notifyDelay delta if delta * opts.factor > tickTime
  startTime = Date.now()

exports.start = (opts) ->
  opts       = assign @defaults, opts
  bound      = tick.bind null, opts
  startTime  = Date.now()
  intervalId = setInterval bound, tickTime
  @

exports.stop = ->
  clearInterval intervalId
  @

exports.defaults =
  factor : 0.4
