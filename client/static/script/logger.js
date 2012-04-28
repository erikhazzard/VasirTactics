' ========================================================================    \n\nLogging System\n    \n======================================================================== ';
var logger;

logger = window.GAME_NAME.logger;

logger.options = {
  log_level: 'all'
};

logger.history = {};

logger.can_log = function(type) {
  'This function takes in a type (e.g., \'warn\') and checks to see if\nit exists in the logger.options.log_level option';
  var log_level, return_value;
  return_value = false;
  log_level = logger.options.log_level;
  if (log_level === 'all' || log_level === true) {
    return_value = true;
  } else if (log_level instanceof Array) {
    if (log_level.indexOf(type) > -1) return_value = true;
  } else if (log_level === null || log_level === void 0 || log_level === 'none' || log_level === false) {
    return_value = false;
  } else {
    if (log_level === type) return_value = true;
  }
  return return_value;
};

logger.log = function(type) {
  'When using logger.log, you must pass in a type\ne.g.\n    logger.debug( arg1, arg2, etc. )';
  var args, cur_date, log_history;
  args = Array.prototype.slice.call(arguments);
  if (!(type != null) || arguments.length === 1) {
    type = 'debug';
    args.splice(0, 0, 'debug');
  }
  if (!logger.can_log(type)) return false;
  cur_date = new Date();
  args.push({
    'Date': cur_date,
    'Milliseconds': cur_date.getMilliseconds(),
    'Time': cur_date.getTime()
  });
  log_history = logger.history;
  log_history[type] = log_history[type] || [];
  log_history[type].push(args);
  if (window.console) console.log(Array.prototype.slice.call(args));
  return true;
};

logger.options.log_types = ['debug', 'error', 'info', 'warn'];

logger.options.setup_log_types = function() {
  'This function will setup log types based on the ones available in\nlogger.options.log_types.  It can be called whenever to \ndynamically add log types';
  var log_type, _i, _len, _ref, _results;
  _ref = logger.options.log_types;
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    log_type = _ref[_i];
    _results.push((function(log_type) {
      return logger[log_type] = function() {
        var args;
        args = Array.prototype.slice.call(arguments);
        args.splice(0, 0, log_type);
        return logger.log.apply(null, args);
      };
    })(log_type));
  }
  return _results;
};

logger.options.setup_log_types();

' ========================================================================    \nConfigure console.log\n======================================================================== ';

if (window.console && logger.options) {
  if (logger.options.log_level === 'none' || logger.options.log_level === null) {
    console.log = function() {
      return {};
    };
  }
}

if (!(window.console != null)) {
  window.console = {
    log: function() {
      return {};
    }
  };
}

window.onerror = function(msg, url, line) {
  logger.error(msg, url, line);
  return false;
};
