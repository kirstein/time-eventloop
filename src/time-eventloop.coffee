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

# Using setTimeout instead of setInterval
# setTimeout gives more precise evaluation of time
# due the fact that if eventloop is blocked at the end of the interval
# it will wait for it to clear
startInterval = (interval, cb) ->
  startTime = Date.now()
  timeoutId = setTimeout (->
    cb()
    startInterval interval, cb
  ), interval

exports.start = (rawOpts) =>
  @stop()
  { color, interval, factor } = assign @defaults, rawOpts
  range.set color
  # Start watching the eventloop ticks
  startInterval interval, ->
    delta = Date.now() - startTime
    notify delta if delta * factor > interval
  this

exports.stop = =>
  clearTimeout timeoutId
  range.clear()
  this

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

