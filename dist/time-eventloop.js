(function() {
  var assign, chalk, notify, startInterval, startTime, timeoutId, util;

  chalk = require('chalk');

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

  notify = function(time) {
    return util.log(chalk.yellow("event loop delayed by: " + time + " ms"));
  };

  startInterval = function(_arg) {
    var factor, interval;
    interval = _arg.interval, factor = _arg.factor;
    startTime = Date.now();
    return timeoutId = setTimeout((function() {
      var delta;
      delta = Date.now() - startTime;
      if (delta * factor > interval) {
        notify(delta);
      }
      return startInterval({
        interval: interval,
        factor: factor
      });
    }), interval);
  };

  exports.start = (function(_this) {
    return function(rawOpts) {
      _this.stop();
      startInterval(assign(_this.defaults, rawOpts));
      return _this;
    };
  })(this);

  exports.stop = (function(_this) {
    return function() {
      clearInterval(timeoutId);
      return _this;
    };
  })(this);

  exports.defaults = {
    factor: .4,
    interval: 4
  };

}).call(this);
