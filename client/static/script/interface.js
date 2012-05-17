(function() {
  ' ========================================================================    \ninterface.coffee\n\nCotains the game\'s Interface.  The interface controls all user interaciton\nwith the game / UI\n\n======================================================================== ';
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
      this.showTarget = __bind(this.showTarget, this);
      this.creatureClicked = __bind(this.creatureClicked, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Interface.__super__.constructor.apply(this, arguments);
    }

    'Renders the interface and handles firing off / listening for events';

    Interface.prototype.initialize = function() {
      return this.model = this.options.model;
    };

    Interface.prototype.render = function() {
      return this;
    };

    Interface.prototype.creatureClicked = function(params) {
      var creature;
      params = params || {};
      creature = params.creature;
      if (creature === void 0) {
        GAME_NAME.logger.error('creatureClicked(): no creature passed in');
        return false;
      }
      this.model.set({
        target: void 0
      });
      creature.get('view').unTarget();
      this.model.set({
        target: creature
      });
      return creature.get('view').target();
    };

    Interface.prototype.showTarget = function() {
      var target;
      target = this.model.get('target');
      if (target) target = target.get('name');
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
      this.on('change:target', this.get('view').showTarget);
      this.on('creature:clicked', this.get('view').creatureClicked);
      return this;
    };

    return Interface;

  })(Backbone.Model);

}).call(this);
