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
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Creature.__super__.constructor.apply(this, arguments);
    }

    Creature.prototype.events = {
      'mouseenter': 'mouseEnter',
      'mouseleave': 'mouseLeave',
      'click': 'target'
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
      this.el = {};
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
      this.$el = creature_group;
      this.delegateEvents();
      return this;
    };

    Creature.prototype.target = function() {
      'Targets this creature.  Updates the UI and\ndarkens the immovable map cells';
      var cell, curEl, el, i, j, mapTiles, rect, selectedEls, _i, _len, _ref;
      $('#game_target_name').html(this.model.get('name') + ' <br /> Health: ' + this.model.get('health'));
      selectedEls = d3.selectAll('.map_tile_selected');
      _ref = selectedEls[0];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        curEl = d3.select(el);
        curEl.attr('class', curEl.attr('class').replace(/map_tile_selected/gi, ''));
      }
      mapTiles = d3.selectAll('.map_tile').attr('class', function(d, i) {
        return d3.select(this).attr('class') + ' tile_disabled';
      });
      for (i = 2; i <= 4; i++) {
        for (j = 2; j <= 4; j++) {
          cell = this.map.get('cells')[i + ',' + j].get('view').$el;
          cell.attr('class', cell.attr('class').replace(/tile_disabled/gi, ''));
        }
      }
      rect = this.$el.select('rect');
      rect.attr('class', rect.attr('class') + ' map_tile_selected');
      return this;
    };

    Creature.prototype.mouseEnter = function() {
      var rect;
      rect = this.$el.select('rect');
      rect.attr('class', rect.attr('class') + ' map_tile_mouse_over');
      return this;
    };

    Creature.prototype.mouseLeave = function() {
      var rect;
      rect = this.$el.select('rect');
      rect.attr('class', rect.attr('class').replace(/map_tile_mouse_over/gi, ''));
      return this;
    };

    return Creature;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Creature = (function(_super) {

    __extends(Creature, _super);

    function Creature() {
      this.initialize = __bind(this.initialize, this);
      Creature.__super__.constructor.apply(this, arguments);
    }

    Creature.prototype.defaults = {
      name: 'Toestubber',
      attack: 1,
      health: 1,
      target: {},
      effects: [],
      abilities: [],
      location: {
        x: Math.round(Math.random() * 5),
        y: Math.round(Math.random() * 5)
      },
      sprite: 'creature_dragoon',
      view: void 0
    };

    Creature.prototype.initialize = function() {
      return this;
    };

    return Creature;

  })(Backbone.Model);

}).call(this);
