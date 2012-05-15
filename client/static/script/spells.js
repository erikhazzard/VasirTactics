(function() {
  ' ========================================================================    \nspells.coffee\n\nContains the class definitions spells\n    Spells instaniated from server\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Creature');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nView\n\n======================================================================== ';

  GAME_NAME.Views.Spells = (function(_super) {

    __extends(Spells, _super);

    function Spells() {
      this.click = __bind(this.click, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Spells.__super__.constructor.apply(this, arguments);
    }

    'Handles the UI / interaction';

    Spells.prototype.initialize = function() {
      if (this.options.model === void 0 || this.options.game === void 0) {
        GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in');
        return false;
      }
      this.model = this.options.model;
      this.game = this.options.game;
      return this;
    };

    Spells.prototype.render = function() {
      return this;
    };

    Spells.prototype.click = function() {
      return 'Called when the UI element is clicked.\nNeed to ensure the user CAN cast the spell';
    };

    return Spells;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Spell = (function(_super) {

    __extends(Spell, _super);

    function Spell() {
      this.renderEffect = __bind(this.renderEffect, this);
      this.initialize = __bind(this.initialize, this);
      Spell.__super__.constructor.apply(this, arguments);
    }

    Spell.prototype.defaults = {
      name: 'Magic Missle',
      cost: 1,
      target: {},
      effect: function() {
        return this;
      }
    };

    Spell.prototype.initialize = function() {
      return this;
    };

    Spell.prototype.renderEffect = function() {
      'This function is called by the renderer and will affect\nthe visible game state somehow';      return this;
    };

    return Spell;

  })(Backbone.Model);

}).call(this);
