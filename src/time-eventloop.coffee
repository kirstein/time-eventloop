chalk = require 'chalk'
util  = require 'util'

timeoutId = null
startTime = null

# Create an obj where the values are extended from `opts` to `defaults`.
assign = (defaults, opts = {}) ->
  res = {}
  for key, val of defaults
    res[key] = opts[key] or val
  res

notify = (time) ->
  util.log chalk.yellow "event loop delayed by: #{time} ms"

startInterval = ({ interval, factor }) ->
  startTime = Date.now()
  timeoutId = setTimeout (->
    delta = Date.now() - startTime
    notify delta if delta * factor > interval
    startInterval { interval, factor }
  ), interval

exports.start = (rawOpts) =>
  @stop()
  startInterval assign @defaults, rawOpts
  @

exports.stop = =>
  clearInterval timeoutId
  @

exports.defaults =
  # Constant used to determinate better range between the real timeout delta and interval
  factor   : .4
  # Interval of the setTimeout. Will be used to determine the diff between real running times
  interval : 4
