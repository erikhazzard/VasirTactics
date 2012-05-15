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
class GAME_NAME.Views.Spells extends Backbone.View
    '''Handles the UI / interaction'''
    initialize: ()=>
        if @options.model == undefined or @options.game == undefined
            GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in')
            return false

        #Set the model
        @model = @options.model
        @game = @options.game

        return @

    render: ()=>
        return @

    #------------------------------------
    #Events - UI User Interaction
    #------------------------------------
    click: ()=>
        '''Called when the UI element is clicked.
            Need to ensure the user CAN cast the spell'''


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
