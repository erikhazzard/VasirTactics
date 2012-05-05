' ========================================================================    \nrenderer.coffee\n\nHandles the actual drawing / rendering of the game\n\n======================================================================== ';
' ========================================================================    \nAdd logging types\n======================================================================== ';
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

GAME_NAME.logger.options.log_types.push('Render');

GAME_NAME.logger.options.setup_log_types();

' ========================================================================    \n\nRenderer\n\n======================================================================== ';

GAME_NAME.Views.Renderer = (function(_super) {

  __extends(Renderer, _super);

  function Renderer() {
    this.drawEntity = __bind(this.drawEntity, this);
    this.init = __bind(this.init, this);
    Renderer.__super__.constructor.apply(this, arguments);
  }

  Renderer.prototype.el = '#canvas_game';

  Renderer.prototype.events = {};

  Renderer.prototype.init = function() {
    this.game = GAME_NAME.game;
    return this.$el = d3.select('canvas_game');
  };

  Renderer.prototype.drawEntity = function(entity) {
    return 'Draws the passed in entity on the screen';
  };

  return Renderer;

})(Backbone.View);

' ========================================================================    \n\nModel\n\n======================================================================== ';

GAME_NAME.Views.Renderer = (function(_super) {

  __extends(Renderer, _super);

  function Renderer() {
    this.initialze = __bind(this.initialze, this);
    Renderer.__super__.constructor.apply(this, arguments);
  }

  'Keeps track of the renderer state';

  Renderer.prototype.defaults = {};

  Renderer.prototype.initialze = function() {
    return this;
  };

  return Renderer;

})(Backbone.Model);
