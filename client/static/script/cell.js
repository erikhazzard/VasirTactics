(function() {
  ' ========================================================================    \ncell.coffee\n\nContains the definition for individual cells that make up the map \n======================================================================== ';
  ' ========================================================================    \nAdd logging types\n======================================================================== ';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  GAME_NAME.logger.options.log_types.push('Cell');

  GAME_NAME.logger.options.setup_log_types();

  ' ========================================================================    \n\nView\n\n======================================================================== ';

  GAME_NAME.Views.Cell = (function(_super) {

    __extends(Cell, _super);

    function Cell() {
      this.handleSpell = __bind(this.handleSpell, this);
      this.targetHtml = __bind(this.targetHtml, this);
      this.mouseLeave = __bind(this.mouseLeave, this);
      this.mouseEnter = __bind(this.mouseEnter, this);
      this.target = __bind(this.target, this);
      this.click = __bind(this.click, this);
      this.enableCell = __bind(this.enableCell, this);
      this.render = __bind(this.render, this);
      this.delegateSVGEvents = __bind(this.delegateSVGEvents, this);
      this.initialize = __bind(this.initialize, this);
      Cell.__super__.constructor.apply(this, arguments);
    }

    Cell.prototype.events = {
      'click': 'click',
      'mouseover': 'mouseEnter',
      'mouseout': 'mouseLeave'
    };

    Cell.prototype.initialize = function() {
      'This cell view is created in Renderer';      if (this.options.model === void 0 || this.options.cellSize === void 0 || this.options.group === void 0) {
        GAME_NAME.logger.error('ERROR', 'cell view: params not properly passed in');
        return false;
      }
      this.model = this.options.model;
      this.model.on('cell:targeted', this.target);
      this.model.on('cell:enableCell', this.enableCell);
      this.model.on('spell:cast', this.handleSpell);
      this.cellSize = this.options.cellSize;
      this.group = this.options.group;
      this.x = this.model.get('x') * this.cellSize.width;
      this.y = this.model.get('y') * this.cellSize.height;
      this.userInterface = GAME_NAME.game.get('userInterface');
      this.el = {};
      return this;
    };

    Cell.prototype.delegateSVGEvents = function() {
      var key, val, _ref;
      _ref = this.events;
      for (key in _ref) {
        val = _ref[key];
        this.d3El.on(key, this[val]);
      }
      return this;
    };

    Cell.prototype.render = function(params) {
      'Render creates the map tile cells and the group containing them\nExpects a renderer model object to be passed in';
      var cellGroup;
      params = params || {};
      if (params.renderer === void 0) {
        GAME_NAME.logger.error('ERROR', 'cell render(): renderer not passed in');
        return false;
      }
      cellGroup = this.group.append('svg:g').attr('class', 'cellGroup cellGroup_' + this.x + ',' + this.y).attr('transform', 'translate(' + [this.x, this.y] + ')');
      this.baseSprite = cellGroup.append('svg:image').attr('class', 'map_tile_image').attr('x', 0).attr('y', 0).attr('width', this.options.cellSize.width).attr('height', this.options.cellSize.height).attr('xlink:href', params.renderer.get('sprites')[this.model.get('baseSprite')]);
      if (this.model.get('topSprite')) {
        this.topSprite = cellGroup.append('svg:image').attr('class', 'map_tile_image_overlay').attr('x', 0).attr('y', 0).attr('width', this.options.cellSize.width).attr('height', this.options.cellSize.height).attr('xlink:href', params.renderer.get('sprites')[this.model.get('topSprite')]);
      }
      this.cellRect = cellGroup.append('svg:rect').attr('class', 'map_tile tile_' + this.x + ',' + this.y).attr('x', 0).attr('y', 0).attr('width', this.options.cellSize.width).attr('height', this.options.cellSize.height);
      this.el = cellGroup.node();
      this.d3El = cellGroup;
      return this.delegateSVGEvents();
    };

    Cell.prototype.enableCell = function() {
      return this.cellRect.classed('tile_disabled', false);
    };

    Cell.prototype.click = function() {
      if (!this.userInterface.get('target') || this.userInterface.get('target').get('className') !== 'creature') {
        return this.userInterface.set({
          target: this.model,
          targetHtml: this.targetHtml()
        });
      } else {
        return this.userInterface.get('target').trigger('creature:move', {
          cell: this.model
        });
      }
    };

    Cell.prototype.target = function() {
      var rect;
      console.log('clicked');
      rect = this.d3El.select('rect');
      rect.classed('map_tile_selected', true);
      return this;
    };

    Cell.prototype.mouseEnter = function() {
      this.cellRect.classed('map_tile_mouse_over', true);
      return this;
    };

    Cell.prototype.mouseLeave = function() {
      this.cellRect.classed('map_tile_mouse_over', false);
      return this;
    };

    Cell.prototype.targetHtml = function() {
      var html;
      html = _.template(GAME_NAME.templates.target_cell)({
        name: this.model.get('name').replace('_', ' '),
        health: ''
      });
      return html;
    };

    Cell.prototype.handleSpell = function(params) {
      params = params || {};
      if (!params.spell) {
        visually.logger.error('cell:handleSpell():', 'no spell passed into handleSpell', 'params: ', params);
      }
      params.spell.get('effect')({
        target: this.d3El,
        model: this.model
      });
      return this;
    };

    return Cell;

  })(Backbone.View);

  ' ========================================================================\n\nModel\n\n======================================================================== ';

  GAME_NAME.Models.Cell = (function(_super) {

    __extends(Cell, _super);

    function Cell() {
      this.target = __bind(this.target, this);
      this.initialize = __bind(this.initialize, this);
      Cell.__super__.constructor.apply(this, arguments);
    }

    Cell.prototype.defaults = {
      name: 'cell_i,j',
      className: 'cell',
      i: 0,
      j: 0,
      baseSprite: '',
      topSprite: '',
      type: '0',
      graphic: ''
    };

    Cell.prototype.initialize = function() {
      return this;
    };

    Cell.prototype.target = function() {
      this.trigger('cell:targeted');
      return this;
    };

    return Cell;

  })(Backbone.Model);

}).call(this);
