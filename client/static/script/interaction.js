(function() {
  ' ========================================================================    \ninteraction.coffee\n\nCotains the game\'s Interface.  The interaction controls all user interaciton\nwith the game / UI\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Interface');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nVIEW \n\n======================================================================== ';

  GAME_NAME.Views.Interface = (function(_super) {

    __extends(Interface, _super);

    function Interface() {
      this.renderTarget = __bind(this.renderTarget, this);
      this.unTargetTiles = __bind(this.unTargetTiles, this);
      this.target = __bind(this.target, this);
      this.nextMove = __bind(this.nextMove, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Interface.__super__.constructor.apply(this, arguments);
    }

    'Renders the interaction and handles firing off / listening for events';

    Interface.prototype.initialize = function() {
      this.model = this.options.model;
      this.model.on('change:target', this.target);
      this.model.on('change:targetHtml', this.renderTarget);
      $('#game_actions_wrapper .next_move').click(this.nextMove);
      return this.$targetEl = $('#game_target_wrapper .game_target');
    };

    Interface.prototype.render = function() {
      return this;
    };

    Interface.prototype.nextMove = function() {
      var creature, creatures, _i, _len;
      creatures = GAME_NAME.game.get('activePlayer').get('creatures').models;
      for (_i = 0, _len = creatures.length; _i < _len; _i++) {
        creature = creatures[_i];
        creature.set({
          'movesLeft': creature.get('moves')
        }, {
          silent: true
        });
      }
      return this.model.set({
        target: void 0
      });
    };

    Interface.prototype.target = function() {
      var target;
      target = this.model.get('target');
      this.unTargetTiles();
      if (target !== void 0) {
        return target.target();
      } else {
        return this.model.set({
          targetHtml: ''
        });
      }
    };

    Interface.prototype.unTargetTiles = function() {
      d3.select('.map_tile_selected').classed('map_tile_selected', false);
      return d3.selectAll('.tile_disabled').classed('tile_disabled', false);
    };

    Interface.prototype.renderTarget = function(params) {
      return this.$targetEl.html(this.model.get('targetHtml'));
    };

    return Interface;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Interface = (function(_super) {

    __extends(Interface, _super);

    function Interface() {
      this.initialize = __bind(this.initialize, this);
      Interface.__super__.constructor.apply(this, arguments);
    }

    Interface.prototype.defaults = {
      target: void 0,
      targetHtml: ''
    };

    Interface.prototype.initialize = function() {
      return this;
    };

    return Interface;

  })(Backbone.Model);

}).call(this);
