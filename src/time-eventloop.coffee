chalk = require 'chalk'
util  = require 'util'

intervalId = null
startTime  = null

assign = (defaults, opts = {}) ->
  res = {}
  for key, val of defaults
    res[key] = opts[key] or val
  res

notifyDelay = (time) ->
  util.log chalk.yellow 'event loop delayed by:', time

tick = ({ factor, interval }) ->
  delta = Date.now() - startTime
  console.log 'here', delta
  notifyDelay delta if delta * factor > interval
  startTime = Date.now()

exports.start = (rawOpts) ->
  opts       = assign @defaults, rawOpts
  bound      = tick.bind null, opts
  startTime  = Date.now()
  intervalId = setInterval bound, opts.interval
  @

exports.stop = ->
  clearInterval intervalId
  @

exports.defaults =
  factor   : 0.4
  interval : 4
