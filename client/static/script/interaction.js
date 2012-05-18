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
      this.target = __bind(this.target, this);
      this.unTargetCreatures = __bind(this.unTargetCreatures, this);
      this.cellClicked = __bind(this.cellClicked, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Interface.__super__.constructor.apply(this, arguments);
    }

    'Renders the interaction and handles firing off / listening for events';

    Interface.prototype.initialize = function() {
      return this.model = this.options.model;
    };

    Interface.prototype.render = function() {
      return this;
    };

    Interface.prototype.cellClicked = function(params) {
      var cell;
      params = params || {};
      cell = params.cell;
      if (cell === void 0) {
        GAME_NAME.logger.error('cellClicked(): no cell passed in');
        return false;
      }
    };

    Interface.prototype.unTargetCreatures = function() {
      d3.select('.map_tile_selected').classed('map_tile_selected', false);
      return d3.selectAll('.tile_disabled').classed('tile_disabled', false);
    };

    Interface.prototype.target = function(params) {
      var target;
      target = this.model.get('target');
      this.unTargetCreatures();
      if (target) {
        target.target();
        target = target.get('name');
      }
      return $('#game_target_name').html(target);
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
      view: void 0
    };

    Interface.prototype.initialize = function() {
      this.set({
        view: new GAME_NAME.Views.Interface({
          model: this
        })
      });
      this.on('change:target', this.get('view').target);
      return this;
    };

    return Interface;

  })(Backbone.Model);

}).call(this);
