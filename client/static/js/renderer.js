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
      this.drawCreatures = __bind(this.drawCreatures, this);
      this.render = __bind(this.render, this);
      this.renderUI = __bind(this.renderUI, this);
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
      this.d3El = d3.select('#game_canvas');
      return this;
    };

    Renderer.prototype.renderUI = function() {
      var activePlayer, key, list_html, player, players, spell, spellView, spells_html, _ref;
      players = this.model.get('game').get('players');
      activePlayer = this.model.get('game').get('activePlayer');
      list_html = [];
      for (key in players) {
        player = players[key];
        list_html.push('<li>' + player.get('name') + ': ' + player.get('health') + 'HP </li>');
      }
      $('#game_player_info_wrapper .player_list').html(list_html.join(''));
      spells_html = [];
      _ref = activePlayer.get('spells');
      for (key in _ref) {
        spell = _ref[key];
        spellView = new GAME_NAME.Views.Spell({
          model: spell
        }).render();
      }
      return this;
    };

    Renderer.prototype.render = function() {
      'This draws all the elements of the game to the screen';      this.drawMap({
        map: this.model.get('game').get('map')
      });
      this.drawCreatures();
      return this;
    };

    Renderer.prototype.drawCreatures = function() {
      'Draw all the creatures for each player';
      var creature, creatures, key, player, players, _fn, _i, _len, _ref,
        _this = this;
      this.creaturesGroup = this.d3El.append('svg:g').attr('class', 'creatures_group');
      players = this.model.get('game').get('players');
      for (key in players) {
        player = players[key];
        creatures = player.get('creatures');
        _ref = creatures.models;
        _fn = function(creature) {
          return _this.drawCreature({
            creature: creature
          });
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          creature = _ref[_i];
          _fn(creature);
        }
      }
      return this;
    };

    Renderer.prototype.drawMap = function(map) {
      'This draws the map by rendering each map tile individually';
      var cell, cells, key, mapTileGroup, val;
      this.mapGroup = this.d3El.append('svg:g').attr('class', 'game_map');
      mapTileGroup = this.mapGroup.append('svg:g').attr('class', 'map_tiles');
      cells = this.model.get('game').get('map').get('cells');
      for (key in cells) {
        val = cells[key];
        cell = new GAME_NAME.Views.Cell({
          model: val,
          cellSize: this.model.get('cellSize'),
          group: mapTileGroup
        });
        cell.render({
          renderer: this.model
        });
      }
      return GAME_NAME.logger.Render('renderer: map rendering complete');
    };

    Renderer.prototype.drawCreature = function(params) {
      'Draws the passed in entity on the screen. Params expects a\ncreature model to be passed in';      params = params || {};
      if (params.creature === void 0) {
        GAME_NAME.logger.error('ERROR! renderer view: drawCreature(): creature not passed in');
        return false;
      }
      if (!params.creature.get('view')) {
        params.creature.set({
          'view': new GAME_NAME.Views.Creature({
            model: params.creature,
            game: this.model.get('game'),
            group: this.creaturesGroup
          })
        });
      }
      params.creature.get('view').render({
        renderer: this,
        group: this.creaturesGroup
      });
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
