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
      this.creatureDeath = __bind(this.creatureDeath, this);
      this.handleSpell = __bind(this.handleSpell, this);
      this.updateTargetHtml = __bind(this.updateTargetHtml, this);
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
      this.game = this.options.game;
      this.map = this.options.game.get('map');
      this.renderer = this.options.game.get('renderer');
      this.cellSize = this.renderer.model.get('cellSize');
      this.group = this.options.group;
      this.interaction = GAME_NAME.game.get('interaction');
      this.model.on('creature:targeted', this.target);
      this.model.on('change:location', this.update);
      this.model.on('change:location', this.target);
      this.model.on('creature:death', this.creatureDeath);
      this.model.on('spell:cast', this.handleSpell);
      this.model.on('change:movesLeft', this.updateTargetHtml);
      this.model.on('change:health', this.updateTargetHtml);
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
      return this.svgEl.transition().duration(900).attr('transform', 'translate(' + [this.x, this.y] + ')');
    };

    Creature.prototype.creatureClicked = function() {
      'Fired off when the user clicks on a creature';      if (this.interaction.get('target') === this.model) {
        this.interaction.set({
          target: void 0
        });
      } else {
        this.interaction.set({
          target: this.model
        });
        this.updateTargetHtml();
      }
      return this;
    };

    Creature.prototype.target = function() {
      var cell, creature_i, creature_j, legitCells, mapCells, mapTiles, rect, selectedEls, _i, _len;
      creature_i = this.model.get('location').x;
      creature_j = this.model.get('location').y;
      selectedEls = d3.selectAll('.map_tile_selected').classed('map_tile_selected', false);
      rect = this.svgEl.select('rect');
      rect.classed('map_tile_selected', true);
      if (!this.model.canUpdateTargetUI()) return this;
      mapTiles = d3.selectAll('.map_tile').classed('tile_disabled', true);
      legitCells = this.model.calculateMovementCells();
      mapCells = this.map.get('cells');
      for (_i = 0, _len = legitCells.length; _i < _len; _i++) {
        cell = legitCells[_i];
        mapCells[cell.get('x') + ',' + cell.get('y')].trigger('cell:enableCell');
      }
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

    Creature.prototype.updateTargetHtml = function() {
      var html;
      html = '';
      if (!(this.model === this.interaction.get('target'))) {
        return false;
      } else {
        if (this.model.belongsToActivePlayer()) {
          html = _.template(GAME_NAME.templates.target_creature_mine)({
            name: this.model.get('name'),
            health: this.model.get('health'),
            movesLeft: this.model.get('movesLeft')
          });
        } else {
          html = _.template(GAME_NAME.templates.target_creature_theirs)({
            name: this.model.get('name'),
            health: this.model.get('health')
          });
        }
        this.interaction.set({
          targetHtml: html
        });
        return this;
      }
    };

    Creature.prototype.handleSpell = function(params) {
      params = params || {};
      if (!params.spell) {
        visually.logger.error('creature:handleSpell():', 'no spell passed into handleSpell', 'params: ', params);
      }
      params.spell.get('effect')({
        target: this.svgEl,
        model: this.model
      });
      return this;
    };

    Creature.prototype.creatureDeath = function() {
      this.svgEl.selectAll('*').transition().duration(1000).style('opacity', 0).delay(1500).remove();
      if (this.model === this.interaction.get('target')) {
        this.interaction.set({
          target: void 0
        });
      }
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
      this.canUpdateTargetUI = __bind(this.canUpdateTargetUI, this);
      this.target = __bind(this.target, this);
      this.belongsToActivePlayer = __bind(this.belongsToActivePlayer, this);
      this.dealDamage = __bind(this.dealDamage, this);
      this.creatureDeath = __bind(this.creatureDeath, this);
      this.checkForDeath = __bind(this.checkForDeath, this);
      this.initialize = __bind(this.initialize, this);
      Creature.__super__.constructor.apply(this, arguments);
    }

    Creature.prototype.defaults = {
      name: 'Toestubber',
      className: 'creature',
      attack: 1,
      health: 2,
      target: {},
      effects: [],
      abilities: [],
      type: ['human'],
      moves: 3,
      movesLeft: 3,
      location: {
        x: Math.round(Math.random() * 5),
        y: Math.round(Math.random() * 5)
      },
      sprite: 'creature_dragoon',
      passType: 'ground',
      owner: void 0
    };

    Creature.prototype.initialize = function() {
      this.on('creature:move', this.move);
      this.on('change:health', this.checkForDeath);
      this.on('creature:death', this.creatureDeath);
      return this;
    };

    Creature.prototype.checkForDeath = function(params) {
      if (this.get('health') < 1) return this.trigger('creature:death');
    };

    Creature.prototype.creatureDeath = function() {
      return GAME_NAME.logger.Creature('Creature died!', 'creature: ' + this.get('name'), 'model: ', this);
    };

    Creature.prototype.dealDamage = function(params) {
      var amount;
      if (typeof params === 'number') {
        params = {
          amount: params
        };
      }
      params = params || {};
      if (!params.amount) {
        GAME_NAME.logger.error('creature model: dealDamage()', 'no amount passed in');
        return false;
      }
      amount = params.amount;
      return this.set({
        health: this.get('health') - amount
      });
    };

    Creature.prototype.belongsToActivePlayer = function() {
      var index;
      index = GAME_NAME.game.get('activePlayer').get('creatures').indexOf(this);
      if (index > -1) {
        return true;
      } else {
        return false;
      }
    };

    Creature.prototype.target = function() {
      this.trigger('creature:targeted');
      return this;
    };

    Creature.prototype.canUpdateTargetUI = function() {
      if (this.belongsToActivePlayer() && this === GAME_NAME.game.get('interaction').get('target')) {
        return true;
      } else {
        return false;
      }
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
            if (this.canMove({
              cell: curCell
            })) {
              movementCells.push(curCell);
            }
          }
        }
      }
      return movementCells;
    };

    Creature.prototype.move = function(params) {
      var cell, deltaMoves, deltaX, deltaY, movesLeft;
      params = params || {};
      cell = params.cell;
      if (!cell) {
        GAME_NAME.logger.error('creature model: move(): no cell passed into params');
        return false;
      }
      if (this.calculateMovementCells().indexOf(cell) < 0) return this;
      if (!this.belongsToActivePlayer()) return this;
      deltaX = Math.abs(this.get('location').x - cell.get('x'));
      deltaY = Math.abs(this.get('location').y - cell.get('y'));
      if (deltaX > deltaY) {
        deltaMoves = deltaX;
      } else {
        deltaMoves = deltaY;
      }
      movesLeft = this.get('movesLeft') - deltaMoves;
      this.set({
        location: {
          x: cell.get('x'),
          y: cell.get('y')
        },
        movesLeft: movesLeft
      });
      return this;
    };

    Creature.prototype.canMove = function(params) {
      var ableToMove, cell;
      params = params || {};
      cell = params.cell;
      if (!cell) {
        GAME_NAME.logger.error('creature model: move(): no cell passed into params');
      }
      ableToMove = false;
      if (cell.get('canPass') === 'all' || cell.get('canPass') === this.get('passType')) {
        ableToMove = true;
      } else {
        ableToMove = false;
      }
      return ableToMove;
    };

    return Creature;

  })(Backbone.Model);

  ' ========================================================================    \n\nColections\n\n======================================================================== ';

  GAME_NAME.Collections.Creatures = (function(_super) {

    __extends(Creatures, _super);

    function Creatures() {
      Creatures.__super__.constructor.apply(this, arguments);
    }

    Creatures.prototype.model = GAME_NAME.Models.Creature;

    return Creatures;

  })(Backbone.Collection);

}).call(this);
