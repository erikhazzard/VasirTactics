(function() {
  ' ========================================================================    \nplayer.coffee\n\nContains the class (view and model) definitions for the player class\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  GAME_NAME.logger.options.log_types.push('Player');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nVIEW \n\n======================================================================== ';

  GAME_NAME.Views.Player = (function(_super) {

    __extends(Player, _super);

    function Player() {
      Player.__super__.constructor.apply(this, arguments);
    }

    'The Player view.  This is basically just an empty class, as \nthere are no elements directly tied to the player';

    return Player;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Player = (function(_super) {

    __extends(Player, _super);

    function Player() {
      this.updateManaUI = __bind(this.updateManaUI, this);
      this.turnEnd = __bind(this.turnEnd, this);
      this.turnBegin = __bind(this.turnBegin, this);
      this.updateHealthFromCreature = __bind(this.updateHealthFromCreature, this);
      this.initialize = __bind(this.initialize, this);
      Player.__super__.constructor.apply(this, arguments);
    }

    Player.prototype.defaults = {
      name: 'Soandso',
      id: 'some_long_string',
      health: 20,
      mana: 3,
      totalMana: 3,
      baseMana: 3,
      regenRate: 0.5,
      target: {},
      spells: [],
      turnsEnded: 0,
      creature: void 0
    };

    Player.prototype.initialize = function() {
      this.on('turn:start', this.turnStart);
      this.on('turn:end', this.turnEnd);
      this.on('change:mana', this.updateManaUI);
      if (this.get('creature')) {
        this.get('creature').on('change:health', this.updateHealthFromCreature);
      }
      return this;
    };

    Player.prototype.updateHealthFromCreature = function() {
      this.set({
        health: this.get('creature').get('health')
      });
      return this;
    };

    Player.prototype.turnBegin = function() {
      return this;
    };

    Player.prototype.turnEnd = function() {
      this.set({
        turnsEnded: this.get('turnsEnded') + 1
      });
      this.set({
        mana: this.get('totalMana')
      });
      return this;
    };

    Player.prototype.updateManaUI = function() {
      if (GAME_NAME.game && GAME_NAME.game.get('activePlayer') === this) {
        GAME_NAME.game.get('userInterface').set({
          manaHtml: this.get('mana')
        });
      }
      return this;
    };

    return Player;

  })(Backbone.Model);

}).call(this);
