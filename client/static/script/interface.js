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
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Interface.__super__.constructor.apply(this, arguments);
    }

    'Renders the interface and handles firing off / listening for events';

    Interface.prototype.initialize = function() {
      return this.on('event:name', this.someFunc);
    };

    Interface.prototype.render = function() {
      return this;
    };

    return Interface;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Interface = (function(_super) {

    __extends(Interface, _super);

    function Interface() {
      Interface.__super__.constructor.apply(this, arguments);
    }

    Interface.prototype.defaults = {};

    return Interface;

  })(Backbone.Model);

}).call(this);
