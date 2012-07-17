(function() {
  ' ========================================================================    \nuser-interface.coffee\n\nCotains the game\'s Interface.  The userInterface controls all user \ninteraciton with the game / UI\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('UserInterface');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nVIEW \n\n======================================================================== ';

  GAME_NAME.Views.UserInterface = (function(_super) {

    __extends(UserInterface, _super);

    function UserInterface() {
      this.changeMana = __bind(this.changeMana, this);
      this.renderTarget = __bind(this.renderTarget, this);
      this.unTargetTiles = __bind(this.unTargetTiles, this);
      this.target = __bind(this.target, this);
      this.endTurn = __bind(this.endTurn, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      UserInterface.__super__.constructor.apply(this, arguments);
    }

    'Renders the interface and handles firing off / listening for events';

    UserInterface.prototype.initialize = function() {
      this.model = this.options.model;
      this.model.on('change:target', this.target);
      this.model.on('change:targetHtml', this.renderTarget);
      this.model.on('change:manaHtml', this.changeMana);
      $('#game_actions_wrapper .end_turn').click(this.endTurn);
      this.$targetEl = $('#game_target_wrapper .game_target');
      this.$manaEl = $('#game_player_mana_wrapper .mana_amount');
      return this;
    };

    UserInterface.prototype.render = function() {
      return this;
    };

    UserInterface.prototype.endTurn = function() {
      GAME_NAME.game.get('activePlayer').trigger('turn:end');
      GAME_NAME.game.get('activePlayer').get('creatures').trigger('creatures:turn:end');
      this.model.set({
        target: void 0
      });
      return this;
    };

    UserInterface.prototype.target = function() {
      var target;
      target = this.model.get('target');
      this.unTargetTiles();
      if (target !== void 0) {
        target.target();
      } else {
        this.model.set({
          targetHtml: ''
        });
      }
      return this;
    };

    UserInterface.prototype.unTargetTiles = function() {
      d3.select('.map_tile_selected').classed('map_tile_selected', false);
      d3.selectAll('.tile_disabled').classed('tile_disabled', false);
      return this;
    };

    UserInterface.prototype.renderTarget = function(params) {
      var html;
      html = this.model.get('targetHtml') || '';
      this.$targetEl.html(html);
      return this;
    };

    UserInterface.prototype.changeMana = function(params) {
      var html;
      html = this.model.get('manaHtml');
      this.$manaEl.html(html);
      return this;
    };

    return UserInterface;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.UserInterface = (function(_super) {

    __extends(UserInterface, _super);

    function UserInterface() {
      this.initialize = __bind(this.initialize, this);
      UserInterface.__super__.constructor.apply(this, arguments);
    }

    UserInterface.prototype.defaults = {
      target: void 0,
      targetHtml: '',
      manaHtml: ''
    };

    UserInterface.prototype.initialize = function() {
      return this;
    };

    return UserInterface;

  })(Backbone.Model);

}).call(this);
