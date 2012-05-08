(function() {
  ' ========================================================================    \ninit.js\n----------------------\nSets up page / UI related stuff and \n========================================================================';
  var _this = this;

  GAME_NAME.init = function() {
    'Kick off the game creation';    GAME_NAME.game = new GAME_NAME.Models.Game();
    GAME_NAME.game.get('renderer').render();
    return _this;
  };

  ' ========================================================================    \nCall init\n========================================================================';

  $(document).ready(function() {
    var key, tmp_img, val, _ref;
    _ref = GAME_NAME.Models.Renderer.prototype.defaults.sprites;
    for (key in _ref) {
      val = _ref[key];
      tmp_img = new Image();
      tmp_img.src = val;
    }
    return GAME_NAME.init();
  });

}).call(this);
