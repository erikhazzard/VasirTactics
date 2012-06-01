(function() {
  ' ========================================================================    \nspells.coffee\n\nContains the class definitions spells\n    Spells instaniated from server\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Spell');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nView\n\n======================================================================== ';

  GAME_NAME.Views.Spell = (function(_super) {

    __extends(Spell, _super);

    function Spell() {
      this.spellCast = __bind(this.spellCast, this);
      this.updateUI = __bind(this.updateUI, this);
      this.click = __bind(this.click, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Spell.__super__.constructor.apply(this, arguments);
    }

    'Handles the spell renderering / user interface';

    Spell.prototype.type = 'li';

    Spell.prototype.initialize = function() {
      if (this.options.model === void 0) {
        GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in');
        return false;
      }
      this.model = this.options.model;
      this.userInterface = GAME_NAME.game.get('userInterface');
      this.el = $('<li class="button">' + this.model.get('name') + '</li>');
      this.el.click(this.click);
      this.model.on('spell:cast', this.spellCast);
      return this;
    };

    Spell.prototype.render = function() {
      $('.spells').append(this.el);
      return this;
    };

    Spell.prototype.click = function() {
      this.model.trigger('spell:cast');
      return this;
    };

    Spell.prototype.updateUI = function() {
      return this;
    };

    Spell.prototype.spellCast = function() {
      var activePlayer, canCast, spellContract, spellMessage, target;
      activePlayer = GAME_NAME.game.get('activePlayer');
      if (activePlayer.get('mana') < this.model.get('cost')) {
        this.userInterface.trigger('spell:insufficientMana');
        GAME_NAME.logger.Spell('Could not cast spell, not enough mana', 'Player mana:', GAME_NAME.game.get('activePlayer').get('mana'), 'Spell cost:', this.model.get('cost'));
        return false;
      }
      target = this.userInterface.get('target');
      if (!target) {
        this.userInterface.trigger('spell:noTarget');
        GAME_NAME.logger.Spell('spellCast(): Interaction model has no target');
        return false;
      }
      spellContract = this.model.get('contract')({
        model: target,
        activePlayer: GAME_NAME.game.get('activePlayer')
      });
      if (typeof spellContract === 'boolean') {
        canCast = spellContract;
        spellMessage = 'Cannot cast spell';
      } else {
        canCast = spellContract.canCast || false;
        spellMessage = spellContract.message || 'Cannot cast spell';
      }
      if (target && canCast) {
        activePlayer.set({
          mana: activePlayer.get('mana') - this.model.get('cost')
        });
        target.trigger('spell:cast', {
          spell: this.model
        });
      } else {
        this.userInterface.trigger('spell:cannotCast', {
          message: spellMessage
        });
        GAME_NAME.logger.Spell('Cannot cast ' + this.model.get('name'), 'spell contract returned false', 'message: ', spellMessage);
      }
      return this;
    };

    return Spell;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Spell = (function(_super) {

    __extends(Spell, _super);

    function Spell() {
      this.initialize = __bind(this.initialize, this);
      Spell.__super__.constructor.apply(this, arguments);
    }

    Spell.prototype.defaults = {
      name: 'Magic Missle',
      cost: 1,
      target: {},
      effect: function(params) {
        return this;
      },
      contract: function(params) {
        return {
          canCast: true,
          message: ''
        };
      }
    };

    Spell.prototype.initialize = function() {
      return this;
    };

    return Spell;

  })(Backbone.Model);

  ' ========================================================================    \n\nColections\n\n======================================================================== ';

  GAME_NAME.Collections.Spells = (function(_super) {

    __extends(Spells, _super);

    function Spells() {
      Spells.__super__.constructor.apply(this, arguments);
    }

    Spells.prototype.model = GAME_NAME.Models.Spell;

    return Spells;

  })(Backbone.Collection);

}).call(this);
