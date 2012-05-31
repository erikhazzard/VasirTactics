''' ========================================================================    
    player.coffee

    Contains the class (view and model) definitions for the player class

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Player')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    VIEW 

    ======================================================================== '''
class GAME_NAME.Views.Player extends Backbone.View
    '''The Player view.  This is basically just an empty class, as 
    there are no elements directly tied to the player'''

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Player extends Backbone.Model
    defaults: {
        name: 'Soandso',
        id: 'some_long_string',
        health: 20,

        #Mana increments by X each Y turns
        mana: 1,
        #Mana regenerated per turn
        regenRate: 0.5,
        
        #current target will point to a creature, player, or map object
        target: {},

        #Spels is a collection of spells this player can use
        spells: [],

        turnsEnded: 0,

        #The player has a 'creature' representation on the game board
        #   this references it
        creature: undefined
    }

    initialize: ()=>
        #Listen for events
        @on('turn:end', @turnEnd)

        if @get('creature')
            @get('creature').on('change:health', @updateHealthFromCreature)

        return @

    updateHealthFromCreature: ()=>
        #When the creature's health is changed, update the player's health
        @set({ health: @get('creature').get('health') })
        return @

    #------------------------------------
    #Game helper functions
    #------------------------------------
    turnEnd: ()=>
        #Called when a player's turn is finished
        #TODO: Any other things that happen - creature cleanup,
        #   spell effects, etc.
        @set({turnsEnded: @get('turnsEnded') + 1})
        return @
