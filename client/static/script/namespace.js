(function() {
  ' ========================================================================    \n namespace.js\n ----------------------\nSets up the namespace for our game, along with setting up any global\n    util functions\n ========================================================================';
  var GAME_NAME,
    _this = this;

  GAME_NAME = (function() {
    return {
      events: _.extend({}, Backbone.Events),
      Views: {},
      Models: {},
      game: {},
      interface: {},
      logger: {},
      init: function() {
        return {};
      },
      util: {}
    };
  })();

  window.GAME_NAME = GAME_NAME;

  ' ========================================================================    \n\nGlobal Functions\n\n========================================================================';

  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();

}).call(this);
