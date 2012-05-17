''' ========================================================================    
    interface.coffee

    Cotains the game's Interface.  The interface controls all user interaciton
    with the game / UI

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Interface')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()
''' ========================================================================    
    
    VIEW 

    ======================================================================== '''
class GAME_NAME.Views.Interface extends Backbone.View
    '''Renders the interface and handles firing off / listening for events'''

    initialize: ()=>
        #Setup events to listen on
        @model = @options.model

    render: ()=>
        #Render the UI
        return @

    #------------------------------------
    #Creature related
    #------------------------------------
    creatureClicked: (params)=>
        params = params || {}
        creature = params.creature
        if creature == undefined
            GAME_NAME.logger.error('creatureClicked(): no creature passed in')
            return false

        #Untarget selected target (if anything is targeted)
        @model.set({ target: undefined })
        creature.get('view').unTarget()

        #Set the target
        @model.set({ target: creature })
        creature.get('view').target()

        
    showTarget: ()=>
        #Show the target in the target box
        #   Targetname may be undefined (if no target)
        target = @model.get('target')
        if target
            target = target.get('name')
        $('#game_target_name').html(target)

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Interface extends Backbone.Model
    defaults: {
        target: undefined
        view: undefined
    }

    initialize: ()=>
        #Called when model is created

        #Create coresponding view
        @set({view: new GAME_NAME.Views.Interface({
            model: @
        })})

        #Setup events
        @on('change:target', @get('view').showTarget)
        @on('creature:clicked', @get('view').creatureClicked)

        return @
