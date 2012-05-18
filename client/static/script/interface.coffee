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
    #
    #Cells
    #
    #------------------------------------
    cellClicked: (params)=>
        params = params || {}
        cell = params.cell
        if cell == undefined
            GAME_NAME.logger.error('cellClicked(): no cell passed in')
            return false
        #Set target to the cell (which triggers target, which
        #   will clear any active creatures targeted


    #------------------------------------
    #
    #Creature related
    #
    #------------------------------------
    unTargetCreatures: ()=>
        #Remove any classes added when creatures get targeted
        d3.select('.map_tile_selected')
            .classed('map_tile_selected', false)

        #Reneable all map tiles
        d3.selectAll('.tile_disabled')
            .classed('tile_disabled', false)
        
    #------------------------------------
    #
    #Target related
    #
    #------------------------------------
    target: (params)=>
        #Targetname may be undefined (if no target)
        target = @model.get('target')

        #Untarget everything else
        @unTargetCreatures()
        
        #Check if target is not undefined
        if target
            #Call the target's target() method
            # (Updates the view)
            target.target()

            target = target.get('name')

        #Update UI
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
        @on('change:target', @get('view').target)

        return @
