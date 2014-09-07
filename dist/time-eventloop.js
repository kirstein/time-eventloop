(function() {
  var assign, chalk, notify, range, startInterval, startTime, timeoutId, util;

  chalk = require('chalk');

  range = require('data-range');

  util = require('util');

  timeoutId = null;

  startTime = null;

  assign = function(defaults, opts) {
    var key, res, val;
    if (opts == null) {
      opts = {};
    }
    res = {};
    for (key in defaults) {
      val = defaults[key];
      res[key] = opts[key] || val;
    }
    return res;
  };

  notify = function(delay) {
    var delayClr, delayMsg;
    delayClr = range.getNext(delay) || range.getLargest();
    delayMsg = delayClr(delay);
    return util.log(chalk.yellow("event loop delayed by: " + delayMsg + " " + (chalk.yellow('ms'))));
  };

  startInterval = function(interval, cb) {
    startTime = Date.now();
    return timeoutId = setTimeout((function() {
      cb();
      return startInterval(interval, cb);
    }), interval);
  };

  exports.start = (function(_this) {
    return function(rawOpts) {
      var color, factor, interval, _ref;
      _this.stop();
      _ref = assign(_this.defaults, rawOpts), color = _ref.color, interval = _ref.interval, factor = _ref.factor;
      range.set(color);
      startInterval(interval, function() {
        var delta;
        delta = Date.now() - startTime;
        if (delta * factor > interval) {
          return notify(delta);
        }
      });
      return _this;
    };
  })(this);

  exports.stop = (function(_this) {
    return function() {
      clearTimeout(timeoutId);
      range.clear();
      return _this;
    };
  })(this);

  exports.defaults = {
    factor: .4,
    interval: 4,
    color: {
      0: chalk.green,
      10: chalk.yellow,
      50: chalk.cyan,
      100: chalk.red
    }
  };

}).call(this);
