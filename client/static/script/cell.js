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
      this.mouseLeave = __bind(this.mouseLeave, this);
      this.mouseEnter = __bind(this.mouseEnter, this);
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      Cell.__super__.constructor.apply(this, arguments);
    }

    Cell.prototype.events = {
      'mouseenter': 'mouseEnter',
      'mouseleave': 'mouseLeave'
    };

    Cell.prototype.initialize = function() {
      'This cell view is created in Renderer';      if (this.options.model === void 0 || this.options.cellSize === void 0 || this.options.group === void 0) {
        GAME_NAME.logger.error('ERROR', 'cell view: params not properly passed in');
        return false;
      }
      this.model = this.options.model;
      this.cellSize = this.options.cellSize;
      this.group = this.options.group;
      this.x = this.model.get('i') * this.cellSize.width;
      this.y = this.model.get('j') * this.cellSize.height;
      this.el = {};
      return this;
    };

    Cell.prototype.render = function() {
      var el;
      el = this.group.append('svg:rect').attr('class', 'map_tile tile_' + this.x + ',' + this.y).attr('x', this.x).attr('y', this.y).attr('width', this.options.cellSize.width).attr('height', this.options.cellSize.height);
      this.el = el.node();
      return this.delegateEvents();
    };

    Cell.prototype.mouseEnter = function() {
      return d3.select(this.el).style('fill', '#6699cc');
    };

    Cell.prototype.mouseLeave = function() {
      return d3.select(this.el).style('fill', '#336699');
    };

    return Cell;

  })(Backbone.View);

  ' ========================================================================    \n\nModel    \n\n======================================================================== ';

  GAME_NAME.Models.Cell = (function(_super) {

    __extends(Cell, _super);

    function Cell() {
      this.initialize = __bind(this.initialize, this);
      Cell.__super__.constructor.apply(this, arguments);
    }

    Cell.prototype.defaults = {
      name: 'cell_i,j',
      type: '0',
      graphic: ''
    };

    Cell.prototype.initialize = function() {
      return this;
    };

    return Cell;

  })(Backbone.Model);

}).call(this);
