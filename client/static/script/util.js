' ========================================================================    \ncreature.coffee\n\nContains the class definitions for creatures\n\n======================================================================== ';
' ========================================================================    \nAdd logging types\n======================================================================== ';
var _this = this;

GAME_NAME.logger.options.log_types.push('Util');

GAME_NAME.logger.options.setup_log_types();

' ========================================================================    \n\nUtils\n\n======================================================================== ';

GAME_NAME.util = (function() {
  var delegateSVGEvents;
  delegateSVGEvents = function(e) {
    return console.log(e);
  };
  return {
    delegateSVGEvents: delegateSVGEvents
  };
})();
