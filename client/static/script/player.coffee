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

        #mana
        #------
        #Info about mana. Mana is the current amount of mana
        mana: 3,
        #totalMana is the totalMana available the player has
        #   mana is set back to this whenever the player ends their turn
        totalMana: 3,
        #baseMana is how much mana the user comes into play with
        baseMana: 3,
        #Mana regenerated per turn
        regenRate: 0.5,
        
        #------
        #current target will point to a creature, player, or map object
        target: {},

        #Spels is a collection of spells this player can use
        spells: [],

        #Keep track of how many turns the player has
        turnsEnded: 0,

        #The player has a 'creature' representation on the game board
        #   this references it
        creature: undefined
    }

    initialize: ()=>
        #Listen for events
        @on('turn:start', @turnStart)
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
    turnBegin: ()=>
        #Called when the player starts their turn
        #
        return @

    turnEnd: ()=>
        #Called when a player's turn is finished
        #TODO: Any other things that happen - creature cleanup,
        #   spell effects, etc.
        #Update turnsEnded
        @set({turnsEnded: @get('turnsEnded') + 1})
        
        #Reset mana
        @set({mana: @get('totalMana')})
        
        #DO OTHER STUFF
        return @
