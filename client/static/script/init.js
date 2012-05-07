(function() {
  ' ========================================================================    \ninit.js\n----------------------\nSets up page / UI related stuff and \n========================================================================';
  var _this = this;

  GAME_NAME.init = function() {
    'Kick off the game creation';    GAME_NAME.game = new GAME_NAME.Models.Game();
    GAME_NAME.game.get('renderer').render();
    return _this;
  };

  ' ========================================================================    \nCall init\n========================================================================';

  GAME_NAME.init();

}).call(this);
