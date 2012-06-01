(function() {
  ' ========================================================================    \ninit.js\n----------------------\nSets up page / UI related stuff and \n========================================================================';
  var key, tmp_img, val, _ref,
    _this = this;

  GAME_NAME.init = function() {
    'Kick off the game creation';
    var creatureEnjalot, creatureEnoex, game_state, magicMissile, renderer, summonCreature;
    magicMissile = function(params) {
      var cellSize, model, target;
      params = params || {};
      model = params.model;
      if (model.get('className') !== 'creature') {
        GAME_NAME.logger.log('Spell', 'Could not cast magic missle. Invalid target');
        return false;
      }
      model.dealDamage(1);
      cellSize = GAME_NAME.Models.Renderer.prototype.defaults.cellSize;
      target = params.target.append('svg:circle').attr('r', 0).attr('cx', cellSize.width / 2).attr('cy', cellSize.height / 2).style('opacity', .8);
      return target.transition().duration(1000).attr('r', 40).style('fill', '#dd2222').each('end', function() {
        return target.transition().duration(700).style('fill', '#ff0000').attr('r', 0).each('end', function() {
          return target.transition().attr('r', 0).style('fill', 'none').remove();
        });
      });
    };
    summonCreature = function(params) {
      var cellSize, model, target;
      params = params || {};
      model = params.model;
      cellSize = GAME_NAME.Models.Renderer.prototype.defaults.cellSize;
      return target = params.target.append('svg:circle').attr('r', cellSize.width / 1.8).attr('cx', cellSize.width / 2).attr('cy', cellSize.height / 2).style('opacity', .9).style('fill', '#6699cc').transition().duration(1000).attr('r', 0).style('fill', '#336699').each('end', function() {
        return target.transition().duration(700).style('fill', '#ffffff').attr('r', 0).each('end', function() {
          return target.transition().attr('r', 0).style('fill', 'none').remove();
        });
      });
    };
    creatureEnoex = new GAME_NAME.Models.Creature({
      name: 'Enoex',
      location: {
        x: 2,
        y: 1
      }
    });
    creatureEnjalot = new GAME_NAME.Models.Creature({
      name: 'Enjalot',
      location: {
        x: 15,
        y: 1
      }
    });
    game_state = {
      players: {
        'enoex': new GAME_NAME.Models.Player({
          name: 'Enoex',
          id: '402190r90war',
          spells: {
            'magic_missile': new GAME_NAME.Models.Spell({
              name: 'Magic Missile',
              effect: magicMissile,
              contract: function(params) {
                var contract;
                if (params.model.get('className') !== 'creature') {
                  contract = {
                    canCast: false,
                    message: 'Can only cast on creatures or players'
                  };
                  return contract;
                } else {
                  return true;
                }
              }
            }),
            'summon_knight': new GAME_NAME.Models.Spell({
              name: 'Summon Creature',
              effect: summonCreature,
              contract: function(params) {
                if (params.model.get('className') !== 'cell') {
                  return false;
                } else {
                  return true;
                }
              }
            })
          },
          creatures: new GAME_NAME.Collections.Creatures([creatureEnoex]),
          creature: creatureEnoex
        }),
        'enjalot': new GAME_NAME.Models.Player({
          name: 'Enjalot',
          id: 'u90r2h180f80n',
          spells: {},
          creatures: new GAME_NAME.Collections.Creatures([creatureEnjalot]),
          creature: creatureEnjalot
        })
      }
    };
    game_state.activePlayer = game_state.players.enoex;
    GAME_NAME.game = new GAME_NAME.Models.Game(game_state);
    renderer = GAME_NAME.game.get('renderer');
    renderer.renderUI();
    renderer.render();
    return _this;
  };

  ' ========================================================================    \nCall init\n========================================================================';

  _ref = GAME_NAME.Models.Renderer.prototype.defaults.sprites;
  for (key in _ref) {
    val = _ref[key];
    tmp_img = new Image();
    tmp_img.src = val;
  }

  $(document).ready(function() {
    GAME_NAME.templates.target_creature_mine = $('#template_ui_target_creature_mine').html();
    GAME_NAME.templates.target_creature_theirs = $('#template_ui_target_creature_theirs').html();
    GAME_NAME.templates.target_cell = $('#template_ui_target_cell').html();
    return GAME_NAME.init();
  });

}).call(this);
