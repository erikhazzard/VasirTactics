' ========================================================================    \n namespace.js\n ----------------------\nSets up the namespace for our game, along with setting up any global\n    util functions\n ========================================================================';
var GAME_NAME;

GAME_NAME = {
  events: {},
  Views: {},
  Models: {},
  game: {
    _state: {},
    render: function() {
      return {};
    }
  },
  interface: {},
  logger: {},
  init: function() {
    return {};
  }
};

window.GAME_NAME = GAME_NAME;

' ========================================================================    \n\nGlobal Functions\n\n========================================================================';

window.requestAnimFrame = (function() {
  return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
    return window.setTimeout(callback, 1000 / 60);
  };
})();
