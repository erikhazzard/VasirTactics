(function() {
  ' ========================================================================    \ncreature.coffee\n\nContains the class definitions for creatures\n\n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Creature');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nVIEW \n\n======================================================================== ';

  GAME_NAME.Views.Creature = (function(_super) {

    __extends(Creature, _super);

    function Creature() {
      this.mouseLeave = __bind(this.mouseLeave, this);
      this.mouseEnter = __bind(this.mouseEnter, this);
      this.target = __bind(this.target, this);
      this.creatureClicked = __bind(this.creatureClicked, this);
      this.update = __bind(this.update, this);
      this.render = __bind(this.render, this);
      this.delegateSVGEvents = __bind(this.delegateSVGEvents, this);
      this.initialize = __bind(this.initialize, this);
      Creature.__super__.constructor.apply(this, arguments);
    }

    Creature.prototype.events = {
      'click': 'creatureClicked'
    };

    Creature.prototype.initialize = function() {
      'This creature view is created in Renderer';      if (this.options.model === void 0 || this.options.game === void 0 || this.options.group === void 0) {
        GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in');
        return false;
      }
      this.model = this.options.model;
      this.model.on('change:location', this.update);
      this.game = this.options.game;
      this.map = this.options.game.get('map');
      this.renderer = this.options.game.get('renderer');
      this.cellSize = this.renderer.model.get('cellSize');
      this.group = this.options.group;
      this.interface = GAME_NAME.game.get('interface');
      this.el = {};
      return this;
    };

    Creature.prototype.delegateSVGEvents = function() {
      var key, val, _ref;
      _ref = this.events;
      for (key in _ref) {
        val = _ref[key];
        this.svgEl.on(key, this[val]);
      }
      return this;
    };

    Creature.prototype.render = function(params) {
      'Handles the actual rendering / drawing of the creature';
      var bg_rect, creature_group;
      this.x = this.model.get('location').x * this.cellSize.width;
      this.y = this.model.get('location').y * this.cellSize.height;
      creature_group = this.group.append('svg:g').attr('class', 'creature_' + this.model.cid).attr('transform', 'translate(' + [this.x, this.y] + ')');
      bg_rect = creature_group.append('svg:rect').attr('class', 'creature_background_rect').attr('x', 0).attr('y', 0).attr('rx', 6).attr('ry', 6).attr('width', this.cellSize.width).attr('height', this.cellSize.height);
      creature_group.append('svg:image').attr('x', 0).attr('y', 0).attr('width', this.cellSize.width).attr('height', this.cellSize.height).attr('xlink:href', this.renderer.model.get('sprites')[this.model.get('sprite')]);
      this.el = creature_group.node();
      this.svgEl = creature_group;
      this.delegateSVGEvents();
      return this;
    };

    Creature.prototype.update = function() {
      this.x = this.model.get('location').x * this.cellSize.width;
      this.y = this.model.get('location').y * this.cellSize.height;
      return this.svgEl.attr('transform', 'translate(' + [this.x, this.y] + ')');
    };

    Creature.prototype.creatureClicked = function() {
      'Fired off when the user clicks on a creature';      if (this.interface.get('target') === this.model) {
        this.interface.set({
          target: void 0
        });
      } else {
        this.interface.set({
          target: this.model
        });
      }
      return this;
    };

    Creature.prototype.target = function() {
      'Targets this creature.  Updates the UI and\ndarkens the immovable map cells';
      var cell, creature_i, creature_j, legitCells, mapCells, mapTiles, rect, selectedEls, _i, _len;
      creature_i = this.model.get('location').x;
      creature_j = this.model.get('location').y;
      selectedEls = d3.selectAll('.map_tile_selected').classed('map_tile_selected', false);
      mapTiles = d3.selectAll('.map_tile').classed('tile_disabled', true);
      legitCells = this.model.calculateMovementCells();
      mapCells = this.map.get('cells');
      for (_i = 0, _len = legitCells.length; _i < _len; _i++) {
        cell = legitCells[_i];
        cell = mapCells[cell.get('x') + ',' + cell.get('y')].get('view').svgEl;
        cell.classed('tile_disabled', false);
      }
      rect = this.svgEl.select('rect');
      rect.classed('map_tile_selected', true);
      return this;
    };

    Creature.prototype.mouseEnter = function() {
      var rect;
      rect = this.svgEl.select('rect');
      rect.classed('map_tile_mouse_over', true);
      return this;
    };

    Creature.prototype.mouseLeave = function() {
      var rect;
      rect = this.svgEl.select('rect');
      rect.classed('map_tile_mouse_over', false);
      return this;
    };

    return Creature;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Creature = (function(_super) {

    __extends(Creature, _super);

    function Creature() {
      this.canMove = __bind(this.canMove, this);
      this.move = __bind(this.move, this);
      this.calculateMovementCells = __bind(this.calculateMovementCells, this);
      this.target = __bind(this.target, this);
      this.initialize = __bind(this.initialize, this);
      Creature.__super__.constructor.apply(this, arguments);
    }

    Creature.prototype.defaults = {
      name: 'Toestubber',
      className: 'creature',
      attack: 1,
      health: 1,
      target: {},
      effects: [],
      abilities: [],
      moves: 3,
      movesLeft: 3,
      location: {
        x: Math.round(Math.random() * 5),
        y: Math.round(Math.random() * 5)
      },
      sprite: 'creature_dragoon',
      type: 'ground',
      view: void 0
    };

    Creature.prototype.initialize = function() {
      return this;
    };

    Creature.prototype.target = function() {
      return this.get('view').target();
    };

    Creature.prototype.calculateMovementCells = function(params) {
      var cells, creatureLocation, curCell, i, j, loopLen, movementCells, movesLeft, rangeLen;
      params = params || {};
      cells = params.cells || GAME_NAME.game.get('map').get('cells');
      movementCells = [];
      creatureLocation = this.get('location');
      movesLeft = this.get('movesLeft');
      loopLen = movesLeft;
      rangeLen = -movesLeft;
      for (i = rangeLen; rangeLen <= loopLen ? i <= loopLen : i >= loopLen; rangeLen <= loopLen ? i++ : i--) {
        for (j = rangeLen; rangeLen <= loopLen ? j <= loopLen : j >= loopLen; rangeLen <= loopLen ? j++ : j--) {
          curCell = cells[(creatureLocation.x + i) + ',' + (creatureLocation.y + j)];
          if (curCell !== void 0) {
            if (curCell.get('canPass') === 'all' || curCell.get('canPass') === this.get('type')) {
              movementCells.push(curCell);
            }
          }
        }
      }
      return movementCells;
    };

    Creature.prototype.move = function(params) {
      var cell;
      params = params || {};
      cell = params.cell;
      if (!cell) {
        GAME_NAME.logger.error('creature model: move(): no cell passed into params');
      }
      return this.set({
        location: {
          x: cell.get('x'),
          y: cell.get('y')
        }
      });
    };

    Creature.prototype.canMove = function(params) {
      var cell;
      params = params || {};
      cell = params.cell;
      if (!cell) {
        GAME_NAME.logger.error('creature model: move(): no cell passed into params');
      }
      return true;
    };

    return Creature;

  })(Backbone.Model);

}).call(this);
