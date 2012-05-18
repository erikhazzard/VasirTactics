(function() {
  ' ========================================================================    \ngame.coffee\n\nCotains the Game model.  A game is instaniated in init and contains\na map, renderer, reference to players, creatures, etc.\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Game');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Game = (function(_super) {

    __extends(Game, _super);

    function Game() {
      this.getMap = __bind(this.getMap, this);
      this.initialize = __bind(this.initialize, this);
      Game.__super__.constructor.apply(this, arguments);
    }

    Game.prototype.defaults = {
      id: 'game_name_01',
      players: {
        playerID: {},
        playerID2: {}
      },
      map: {},
      renderer: {},
      _state: {}
    };

    Game.prototype.initialize = function() {
      'Set everything up';
      var gameSetup;
      gameSetup = {};
      gameSetup.map = new GAME_NAME.Models.Map();
      gameSetup.renderer = new GAME_NAME.Views.Renderer({
        game: this
      });
      gameSetup.interaction = new GAME_NAME.Models.Interface();
      this.set(gameSetup);
      return this;
    };

    Game.prototype.getMap = function() {
      return 'This function will get the map from the server';
    };

    return Game;

  })(Backbone.Model);

}).call(this);
