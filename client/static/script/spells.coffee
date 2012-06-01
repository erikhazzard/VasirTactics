''' ========================================================================    
    spells.coffee

    Contains the class definitions spells
        Spells instaniated from server

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Spell')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()
''' ========================================================================    
    
    View

    ======================================================================== '''
class GAME_NAME.Views.Spell extends Backbone.View
    '''Handles the spell renderering / user interface'''
    type: 'li'

    initialize: ()=>
        if @options.model == undefined
            GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in')
            return false

        #Set the model
        @model = @options.model
        #Store ref to the userInterface object
        @userInterface = GAME_NAME.game.get('userInterface')

        #Create this element
        @el = $('<li class="button">' + @model.get(
            'name') + '</li>')

        #Listen for events
        #TODO: put this in view's events
        @el.click(@click)

        #Listen for events on the model
        @model.on('spell:cast', @spellCast)

        return @

    render: ()=>
        #Renders the spell button in the UI
        $('.spells').append(@el)

        return @

    #------------------------------------
    #Events - UI User Interaction
    #------------------------------------
    click: ()=>
        #Called when the UI element is clicked.
        #Fire the spellCast event
        @model.trigger('spell:cast')
        return @

    #Update UI (show / hide based on current target)
    updateUI: ()=>
        #This is triggered when the game's Interaction model receives
        #   a new target 
        return @

    #------------------------------------
    #Spell interaction
    #------------------------------------
    spellCast: ()=>
        #The process of casting a spell:
        #   1. Determine if spell can be cast (this function)
        #   2. get current target's model
        #   3. fire event on that model and pass in this spell's model
        #   4. the target's view listens on it's model to catch the event
        #       we fire off
        #   5. a function in the target's view gets called, and calls
        #       this model's effect() function, passing in the view's
        #       element
        activePlayer = GAME_NAME.game.get('activePlayer')

        #Make sure user has enough mana, etc.
        if activePlayer.get('mana') < @model.get('cost')
            #Trigger event
            @userInterface.trigger('spell:insufficientMana')

            #Log message
            GAME_NAME.logger.Spell('Could not cast spell, not enough mana',
                'Player mana:',
                GAME_NAME.game.get('activePlayer').get('mana'),
                'Spell cost:',
                @model.get('cost')
            )
            return false
        #Make sure there is a target (unless the spell doesn't
        #   need one)
        target = @userInterface.get('target')

        #TODO: support multiple targets
        #TODO: cast without target
        if not target
            @userInterface.trigger('spell:noTarget')
            GAME_NAME.logger.Spell('spellCast(): Interaction model has no target')
            return false

        #Check if the spell can be cast
        #--------------------------------
        #   The spellContract returns an object containing a canCast { boolean }
        #       indicating if the spell can be cast, and a message { string }
        #       containing the error message if it can't
        #TODO: make the params more robust, pass in more things
        spellContract = @model.get('contract')({
            model: target,
            activePlayer: GAME_NAME.game.get('activePlayer')
        })

        #Note: contract can just return a boolean.  If it does, we 
        #   need to check for it
        if typeof spellContract == 'boolean'
            canCast = spellContract
            spellMessage = 'Cannot cast spell'
        else
            canCast = spellContract.canCast || false
            spellMessage = spellContract.message || 'Cannot cast spell'

        #Check it
        if target and canCast
            #We can cast the spell, so do it
            #Update player's mana
            activePlayer.set({ mana: activePlayer.get('mana') - @model.get('cost') })
            target.trigger('spell:cast', {
                spell: @model
            })
        else
            @userInterface.trigger('spell:cannotCast', {
                message: spellMessage
            })
            GAME_NAME.logger.Spell(
                'Cannot cast ' + @model.get('name'),
                'spell contract returned false',
                'message: ',
                spellMessage)

        return @

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Spell extends Backbone.Model
    defaults: {
        name: 'Magic Missle'

        #the cost is how much mana (or whatever 'currency' we use) this spell
        #   requires
        cost: 1,

        #current target will (usually) point to a creature or player object
        target: {},

        effect: (params)->
            #this is a callback returned from the server which will do 
            #   something to the target
            return @

        contract: (params)->
            return {canCast: true, message: ''}
    }

    initialize: ()=>
        return @

''' ========================================================================    
    
    Colections

    ======================================================================== '''
class GAME_NAME.Collections.Spells extends Backbone.Collection
    model: GAME_NAME.Models.Spell
