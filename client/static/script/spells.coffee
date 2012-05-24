''' ========================================================================    
    spells.coffee

    Contains the class definitions spells
        Spells instaniated from server

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Creature')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()
''' ========================================================================    
    
    View

    ======================================================================== '''
class GAME_NAME.Views.Spell extends Backbone.View
    '''Handles the UI / interaction'''
    type: 'li'

    initialize: ()=>
        if @options.model == undefined
            GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in')
            return false

        #Set the model
        @model = @options.model

        #List for events
        GAME_NAME.game.get('interaction').on('change:target', @updateUI)

        return @

    render: ()=>
        #Renders the spell button in the UI
        @el = $('<li class="button">' + @model.get(
            'name') + '</li>')
        $('.spells').append(@el)
        return @

    #------------------------------------
    #Events - UI User Interaction
    #------------------------------------
    click: ()=>
        '''Called when the UI element is clicked.
            Need to ensure the user CAN cast the spell'''
        return @

    #------------------------------------
    #Update UI (show / hide based on current target)
    #------------------------------------
    updateUI: ()=>
        #This is triggered when the game's Interaction model receives
        #   a new target 
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

        effect: ()->
            #this is a callback returned from the server which will do 
            #   something to the target
            return @
    }

    initialize: ()=>
        return @

    renderEffect: ()=>
        '''This function is called by the renderer and will affect
        the visible game state somehow'''
        return @
