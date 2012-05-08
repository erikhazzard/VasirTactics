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
      this.drawCreature = __bind(this.drawCreature, this);
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
      'This draws all the elements of the game to the screen';      $(this.$el.node()).empty();
      this.drawMap({
        map: this.model.get('game').get('map')
      });
      return this.drawCreature({
        creature: new GAME_NAME.Models.Creature({})
      });
    };

    Renderer.prototype.drawMap = function(map) {
      'This draws the map by rendering each map tile individually';
      var cell, key, mapTileGroup, val, _ref;
      this.mapGroup = this.$el.append('svg:g').attr('class', 'game_map');
      mapTileGroup = this.mapGroup.append('svg:g').attr('class', 'map_tiles');
      _ref = this.model.get('game').get('map').get('cells');
      for (key in _ref) {
        val = _ref[key];
        cell = new GAME_NAME.Views.Cell({
          model: val,
          cellSize: this.model.get('cellSize'),
          group: mapTileGroup
        });
        val.set({
          'view': cell
        });
        cell.render({
          renderer: this.model
        });
      }
      return GAME_NAME.logger.Render('renderer: map rendering complete');
    };

    Renderer.prototype.drawCreature = function(params) {
      'Draws the passed in entity on the screen. Params expects a\ncreature model to be passed in';
      var creature_group, x, y;
      params = params || {};
      if (params.creature === void 0) {
        GAME_NAME.logger.error('ERROR! renderer view: drawCreature(): creature not passed in');
        return false;
      }
      x = params.creature.get('location').x * this.model.get('cellSize').width;
      y = params.creature.get('location').y * this.model.get('cellSize').height;
      creature_group = this.mapGroup.append('svg:g').attr('class', 'creature_' + params.creature.cid).attr('transform', 'translate(' + [x, y] + ')');
      creature_group.append('svg:image').attr('x', 0).attr('y', 0).attr('width', this.model.get('cellSize').width).attr('height', this.model.get('cellSize').height).attr('xlink:href', this.model.get('sprites')[params.creature.get('sprite')]);
      return this;
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
        height: 48,
        width: 48
      },
      sprites: {
        'terrain_0': '/static/image/sprites/map/grass_bg.png',
        'terrain_1': '/static/image/sprites/map/blue_grass.jpg',
        'terrain_2': '/static/image/sprites/map/road.jpg',
        'rock': '/static/image/sprites/map/rock.png',
        'creature_dragoon': '/static/image/sprites/creatures/dragoon.png'
      }
    };

    Renderer.prototype.initialize = function() {
      'When this renderer model is instaniated, store a reference to the\ngame object';      return this;
    };

    return Renderer;

  })(Backbone.Model);

}).call(this);
