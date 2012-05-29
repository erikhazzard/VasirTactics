(function() {
  ' ========================================================================    \ntests.coffee\n\nContains all the unit tests for this app\nTODO: Break this into multiple files\n\nSome common test functions\n----------------------\nok ( state, message ) – passes if the first argument is truthy\nequal ( actual, expected, message ) – a simple comparison assertion with\n    type coercion\n\nnotEqual ( actual, expected, message ) – the opposite of the above\n\nexpect( amount ) – the number of assertions expected to run within each test\n\nstrictEqual( actual, expected, message) – offers a much stricter comparison\n    than equal() and is considered the preferred method of checking equality\n    as it avoids stumbling on subtle coercion bugs\n\ndeepEqual( actual, expected, message ) – similar to strictEqual, comparing \n    the contents (with ===) of the given objects, arrays and primitives.\n======================================================================== ';
  $(document).ready(function() {
    ' ====================================================================\n\nGAME_NAME Tests\n\n==================================================================== ';    GAME_NAME.logger.options.log_level = true;
    ' ====================================================================\nCreature\n\nTesting a creature \n==================================================================== ';
    module('CREATURE: model', {
      setup: function() {
        this.creature = new GAME_NAME.Models.Creature({});
        ok(this.creature !== void 0, 'Empty creature created successfully in setup()');
        return this;
      },
      teardown: function() {
        return this;
      }
    });
    test('Model: default properties are set', function() {
      equal(this.creature.get('health') > -1, true, 'Creature starts with > -1 health');
      return this;
    });
    test('Model: creature:move event works', function() {
      var moveSpy;
      moveSpy = this.spy();
      this.creature.on('creature:move', moveSpy);
      this.creature.trigger('creature:move');
      equal(moveSpy.callCount, 1, 'creature:move fires off an event');
      return this;
    });
    test('move(): function works', function() {
      return equal(this.creature.move(), false, 'Calling move() returns false with no params');
    });
    test('Model: creature:health change event works', function() {
      var deathSpy, healthSpy, origHealth;
      healthSpy = this.spy();
      origHealth = this.creature.get('health');
      this.creature.on('change:health', healthSpy);
      this.creature.set({
        health: origHealth - 1
      });
      equal(healthSpy.callCount, 1, 'change:health fires off an event');
      equal(this.creature.get('health'), origHealth - 1, 'setting health to health-1 works properly');
      deathSpy = this.spy();
      this.creature.on('creature:death', deathSpy);
      this.creature.set({
        health: 0
      });
      equal(deathSpy.callCount, 1, 'creature:death event fired when health < 1');
      return this;
    });
    ' ====================================================================\nPLAYER\n\nTesting a player\n==================================================================== ';
    module('PLAYER: model', {
      setup: function() {
        this.player = new GAME_NAME.Models.Player({});
        ok(this.player !== void 0, 'Empty player created successfully in setup()');
        return this;
      },
      teardown: function() {
        return this;
      }
    });
    test('Model: default properties are set', function() {
      equal(this.player.get('health') > -1, true, 'Player starts with > -1 health');
      return this;
    });
    return test('Turns completed is updated when a turn is made', function() {
      var origTurns, turnSpy;
      turnSpy = this.spy();
      origTurns = this.player.get('turnsEnded');
      this.player.on('turn:end', turnSpy);
      this.player.trigger('turn:end');
      equal(turnSpy.callCount, 1, 'turn:end fires off event');
      equal(this.player.get('turnsEnded'), origTurns + 1, 'turn:end increments turnsEnded property properly');
      return this;
    });
  });

}).call(this);
