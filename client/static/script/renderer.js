(function() {
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
      this.drawMap = __bind(this.drawMap, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Renderer.__super__.constructor.apply(this, arguments);
    }

    Renderer.prototype.el = '#canvas_game';

    Renderer.prototype.events = {};

    Renderer.prototype.initialize = function() {
      'Create the renderer view.  This should be called from game.js';      if (this.options.game === void 0) {
        GAME_NAME.logger.error('ERROR! renderer view: options.game not set, pass in game!');
        return false;
      }
      this.model = new GAME_NAME.Models.Renderer({
        game: this.options.game
      });
      return this.$el = d3.select('#game_canvas');
    };

    Renderer.prototype.render = function() {
      'This draws all the elements of the game to the screen';      return this.drawMap({
        map: this.model.get('game').get('map')
      });
    };

    Renderer.prototype.drawMap = function(map) {
      'This draws the map by rendering each map tile individually';
      var cell, key, mapGroup, val, _ref;
      mapGroup = this.$el.append('svg:g').attr('class', 'game_map');
      _ref = this.model.get('game').get('map').get('cells');
      for (key in _ref) {
        val = _ref[key];
        cell = new GAME_NAME.Views.Cell({
          model: val,
          cellSize: this.model.get('cellSize'),
          group: mapGroup
        });
        val.set({
          'view': cell
        });
        cell.render();
      }
      return GAME_NAME.logger.Render('renderer: map rendering complete');
    };

    Renderer.prototype.drawEntity = function(entity) {
      return 'Draws the passed in entity on the screen';
    };

    return Renderer;

  })(Backbone.View);

  ' ========================================================================    \n\nModel\n\n======================================================================== ';

  GAME_NAME.Models.Renderer = (function(_super) {

    __extends(Renderer, _super);

    function Renderer() {
      this.initialize = __bind(this.initialize, this);
      Renderer.__super__.constructor.apply(this, arguments);
    }

    'Keeps track of the renderer state';

    Renderer.prototype.defaults = {
      cellSize: {
        height: 42,
        width: 42
      }
    };

    Renderer.prototype.initialize = function() {
      'When this renderer model is instaniated, store a reference to the\ngame object';      return this;
    };

    return Renderer;

  })(Backbone.Model);

}).call(this);
