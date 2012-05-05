' ========================================================================    \nspells.coffee\n\nContains the class definitions spells\n    Spells instaniated from server\n\n======================================================================== ';
' ========================================================================    \nAdd logging types\n======================================================================== ';
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

GAME_NAME.logger.options.log_types.push('Spells');

GAME_NAME.logger.options.setup_log_types();

' ========================================================================    \n\nModel    \n\n======================================================================== ';

GAME_NAME.Models.Spells = (function(_super) {

  __extends(Spells, _super);

  function Spells() {
    this.initialize = __bind(this.initialize, this);
    Spells.__super__.constructor.apply(this, arguments);
  }

  Spells.prototype.defaults = {
    name: 'Magic Missle',
    target: {},
    effects: [],
    abilities: []
  };

  Spells.prototype.initialize = function() {
    return this;
  };

  return Spells;

})(Backbone.Model);
