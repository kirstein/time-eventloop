chalk = require 'chalk'
range = require 'data-range'
util  = require 'util'

timeoutId = null
startTime = null

# Create an obj where the values are extended from `opts` to `defaults`.
assign = (defaults, opts = {}) ->
  res = {}
  for key, val of defaults
    res[key] = opts[key] or val
  res

notify = (delay) ->
  delayClr = range.getNext(delay) or range.getLargest()
  delayMsg = delayClr delay
  util.log chalk.yellow "event loop delayed by: #{delayMsg} #{chalk.yellow 'ms'}"

startInterval = ({ interval, factor }) ->
  startTime = Date.now()
  timeoutId = setTimeout (->
    delta = Date.now() - startTime
    notify delta if delta * factor > interval
    startInterval { interval, factor }
  ), interval

exports.start = (rawOpts) =>
  @stop()
  opts = assign @defaults, rawOpts
  range.set opts.color
  startInterval opts
  @

exports.stop = =>
  clearInterval timeoutId
  range.clear()
  @

exports.defaults =
  # Constant used to determinate better range between the real timeout delta and interval
  factor   : .4
  # Interval of the setTimeout. Will be used to determine the diff between real running times
  interval : 4
  # Warning colors according to delayed MS
  color:
    0   : chalk.green
    10  : chalk.yellow
    50  : chalk.cyan
    100 : chalk.red

