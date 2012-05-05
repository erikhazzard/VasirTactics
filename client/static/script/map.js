' ========================================================================    \nmap.coffee\n\nContains the definition for map, which is retrieved from server and made\nup of cells.  A Map object is made up of map cells and the Map\nis owned by the Game object\n\n======================================================================== ';
' ========================================================================    \nAdd logging types\n======================================================================== ';
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

GAME_NAME.logger.options.log_types.push('Map');

GAME_NAME.logger.options.setup_log_types();

' ========================================================================    \n\nModel    \n\n======================================================================== ';

GAME_NAME.Models.Map = (function(_super) {

  __extends(Map, _super);

  function Map() {
    this.setupCells = __bind(this.setupCells, this);
    this.initialize = __bind(this.initialize, this);
    Map.__super__.constructor.apply(this, arguments);
  }

  Map.prototype.defaults = {
    name: 'Faydwer',
    map_array: [
      [
        {
          type: 0
        }, {
          type: 0
        }
      ], [
        {
          type: 0
        }, {
          type: 0
        }
      ]
    ],
    cells: {}
  };

  Map.prototype.initialize = function() {
    setupCells({
      cells: this.map_array
    });
    return this;
  };

  Map.prototype.setupCells = function(params) {
    'Setup the game cells.  This is called from init and\nthe cells are setup based on this model\'s map array\nTakes in a array of cells ';
    var cell, _i, _len, _ref, _results;
    params = params || {};
    params.cells = params.cells || [];
    _ref = params.cells;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cell = _ref[_i];
      _results.push(GAME_NAME.logger.Map('cell: ', cell));
    }
    return _results;
  };

  return Map;

})(Backbone.Model);
