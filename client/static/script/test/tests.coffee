''' ========================================================================    
    tests.coffee

    Contains all the unit tests for this app
    TODO: Break this into multiple files

    Some common test functions
    ----------------------
    ok ( state, message ) – passes if the first argument is truthy
    equal ( actual, expected, message ) – a simple comparison assertion with
        type coercion

    notEqual ( actual, expected, message ) – the opposite of the above

    expect( amount ) – the number of assertions expected to run within each test

    strictEqual( actual, expected, message) – offers a much stricter comparison
        than equal() and is considered the preferred method of checking equality
        as it avoids stumbling on subtle coercion bugs

    deepEqual( actual, expected, message ) – similar to strictEqual, comparing 
        the contents (with ===) of the given objects, arrays and primitives.
    ======================================================================== '''
$(document).ready( ()->
    ''' ====================================================================

        GAME_NAME Tests

        ==================================================================== '''
    #Set logging level
    GAME_NAME.logger.options.log_level = true
 
    ''' ====================================================================
        Creature

        Testing a creature 
        ==================================================================== '''
    module('CREATURE: model',{
        setup: ()->
            @creature = new GAME_NAME.Models.Creature({})

            ok(@creature != undefined,
                'Empty creature created successfully in setup()')
            return @

        teardown: ()->
            return @
    })

    test('Model: default properties are set', ()->
        equal(
            @creature.get('health') > -1,
            true,
            'Creature starts with > -1 health')
        return @
    )

    #------------------------------------
    #MOVE Related
    #------------------------------------
    #Events
    test('Model: creature:move event works', ()->
        moveSpy = @spy()
        @creature.on('creature:move', moveSpy)
        @creature.trigger('creature:move')
        equal(
            moveSpy.callCount
            1,
            'creature:move fires off an event')
        return @
    )

    #Functions
    #------------------------------------
    test('move(): function works', ()->
        #No params should return false
        equal(@creature.move(), false,
            'Calling move() returns false with no params')
    )

    #------------------------------------
    #HEALTH Related
    #------------------------------------
    test('Model: creature:health change event works', ()->
        healthSpy = @spy()
        origHealth = @creature.get('health')

        @creature.on('change:health', healthSpy)
        @creature.set({health: origHealth - 1 })

        equal(
            healthSpy.callCount
            1,
            'change:health fires off an event')
        equal(
            @creature.get('health')
            origHealth-1,
            'setting health to health-1 works properly')

        #Test that the creature death event gets fired off if health < 1
        deathSpy = @spy()
        @creature.on('creature:death', deathSpy)

        #Set the health to 0
        @creature.set({health: 0})
        equal(
            deathSpy.callCount,
            1,
            'creature:death event fired when health < 1')
        return @
    )


    ''' ====================================================================
        PLAYER

        Testing a player
        ==================================================================== '''
    module('PLAYER: model',{
        setup: ()->
            @player = new GAME_NAME.Models.Player({
                creature: new GAME_NAME.Models.Creature({})
            })

            ok(@player != undefined,
                'Empty player created successfully in setup()')
            return @

        teardown: ()->
            return @
    })

    test('Model: default properties are set', ()->
        equal(
            @player.get('health') > -1,
            true,
            'Player starts with > -1 health')
        return @
    )
    test('Turns completed is updated when a turn is made', ()->
        turnSpy = @spy()
        origTurns = @player.get('turnsEnded')

        @player.on('turn:end', turnSpy)
        @player.trigger('turn:end')

        equal(
            turnSpy.callCount,
            1,
            'turn:end fires off event')
        equal(
            @player.get('turnsEnded'),
            origTurns + 1,
            'turn:end increments turnsEnded property properly')
        return @
    )

    test('Mana updates properly', ()->
        #check that it updates and corresponding events are called
        turnSpy = @spy()
        origMana = @player.get('mana')

        @player.set({mana: origMana - 1})

        equal(
            origMana-1,
            @player.get('mana'),
            'mana updates properly when one mana point is removed')

        #End turn, mana should reset
        @player.on('turn:end', turnSpy)
        @player.trigger('turn:end')

        equal(
            @player.get('mana'),
            @player.get('totalMana'),
            'Mana is reset to totalMana at end of turn')
        return @
    )

    test('Player health is updated when their creature is hurt', ()->
        @creature = @player.get('creature')
        creatureHealth = @creature.get('health')
        @creature.set({ health: creatureHealth - 1 })

        equal(
            @creature.get('health'),
            @player.get('health'),
            'Creature health and player health are same after creature takes damage')
        return @
    )

    ''' ====================================================================
        USER INTERFACE

        Testing the user interface 
        ==================================================================== '''
    module('USER INTERFACE: model',{
        setup: ()->
            @userInterface= new GAME_NAME.Models.UserInterface({})

            ok(@userInterface != undefined,
                'Empty player created successfully in setup()')
            return @

        teardown: ()->
            return @
    })

    test('properties are set', ()->
        equal(
            @userInterface.get('target')
            undefined,
            'default target is undefined')
        return @
    )

    ''' ====================================================================
        SPELLS

        Testing the spells
        ==================================================================== '''
    module('SPELLS: model',{
        setup: ()->
            #Note: Here we'll create an example spell (magic missle) to use to
            #   test the spell class against.  Eventually, on the server side,
            #   we'll need to unit test all spells
            @spell = new GAME_NAME.Models.Spell({
                name: 'Magic Missile'
                effect: (params)=>
                    #No need for an effect, since we're just testing the model 
                    return @
                contract: (params)=>
                    if params.model.get('className') != 'creature'
                        contract = {
                            canCast: false,
                            message: 'Can only cast on creatures or players'
                        }
                        return contract
                    else
                        return true
            })
            ok(@spell != undefined,
                'Magic missile spell created successfully in setup()')
            return @

        teardown: ()->
            return @
    })

    test('spells cast counters update', ()->
        castSpy = @spy()
        counterAll = @spell.get('totalTimesCast')
        counterTurn = @spell.get('timesCastThisTurn')

        @spell.on('spell:castSuccess', castSpy)

        @spell.trigger('spell:castSuccess')

        #Make sure event fired
        equal(
            castSpy.callCount,
            1,
            'spell:castSuccess triggers event successfully')
        
        equal(
            @spell.get('totalTimesCast'),
            counterAll + 1,
            'totalTimesCast counter is correct after casting spell')

        return @
    )


)
