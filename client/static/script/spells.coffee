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
        #Make sure user has enough mana, etc.
        if not true
            return false

        #Make sure there is a target (unless the spell doesn't
        #   need one)
        #TODO: cast without target
        #TODO: support multiple targets
        target = GAME_NAME.game.get('interaction').get('target')

        #Make sure the target exists
        if target
            target.trigger('spell:cast', {
                spell: @model
            })
        else
            GAME_NAME.logger.Creature('spellCast(): Interaction model has no target')
            return false

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

        effect: (target)->
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

''' ========================================================================    
    
    Colections

    ======================================================================== '''
class GAME_NAME.Collections.Spells extends Backbone.Collection
    model: GAME_NAME.Models.Spell
