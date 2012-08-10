''' ========================================================================    
    user-interface.coffee

    Cotains the game's Interface.  The userInterface controls all user 
    interaciton with the game / UI

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('UserInterface')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()
''' ========================================================================    
    
    VIEW 

    ======================================================================== '''
class GAME_NAME.Views.UserInterface extends Backbone.View
    '''Renders the interface and handles firing off / listening for events'''

    initialize: ()=>
        #Setup events to listen on
        @model = @options.model

        #Setup events
        @model.on('change:target', @target)
        @model.on('change:targetHtml', @renderTarget)
        #player mana
        #   Note: We don't listen on the active player, because that player
        #       may change each turn (in a hotseat game)
        @model.on('change:manaHtml', @changeMana)

        #TODO: turn this into a view
        $('#game_actions_wrapper .end_turn').click(@endTurn)

        #Store refs to dom nodes
        #-------------------------
        @$targetEl = $('#game_target_wrapper .game_target')
        @$manaEl = $('#game_player_mana_wrapper .mana_amount')
        return @

    render: ()=>
        #Render the UI
        return @

    #------------------------------------
    #
    #Next move
    #
    #------------------------------------
    endTurn: ()=>
        #Next turn, do stuff
        #TODO: More stuff needs to happen here. 
        #   -Send data to server

        #Fire off turn:end event on player
        GAME_NAME.game.get('activePlayer').trigger('turn:end')

        #Fire off some global next turn event which all models will
        #   listen for (on the game model)
        
        #Reset all creature moves
        GAME_NAME.game.get('activePlayer').get('creatures').trigger('creatures:turn:end')

        #Clear out the target
        @model.set({
            target: undefined
        })
        return @

    #------------------------------------
    #
    #Target related
    #
    #------------------------------------
    target: ()=>
        #Targetname may be undefined (if no target)
        target = @model.get('target')

        #Untarget everything else
        @unTargetTiles()
        
        #Check if target is not undefined
        if target != undefined
            #Call the target's target() method
            # (Updates the view)
            target.target()

        else
            #Target is not defined, so make sure we clear the
            #   targetHTML
            #Bad target html
            @model.set({targetHtml: ''})

        return @
            
    unTargetTiles: ()=>
        #Remove any classes added when creatures get targeted
        d3.select('.map_tile_selected')
            .classed('map_tile_selected', false)

        #Reneable all map tiles
        d3.selectAll('.tile_disabled')
            .classed('tile_disabled', false)

        #Enable all cells
        cells = GAME_NAME.game.get('map').get('cells')
        #Set each cell to be enabledk
        _.each(cells, (cell)=>
            cell.set({'cellEnabled': true})
        )

        GAME_NAME.logger.log('UserInterface', 'unTargetTiles(): enabled all cells')
        return @

    renderTarget: (params)=>
        #Updates the target box UI HTML
        html = @model.get('targetHtml') || ''
        @$targetEl.html(html)
        return @

    #------------------------------------
    #
    #Update Mana HTML
    #
    #------------------------------------
    changeMana: (params)=>
        #TODO: Make this more extensible? General function for updating
        #   individual templates?
        #Updates the mana displayed in the interface
        #params:
        #   (required) mana: number to show
            
        html = @model.get('manaHtml')
        @$manaEl.html(html)
        return @

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.UserInterface extends Backbone.Model
    defaults: {
        target: undefined
        targetHtml: ''

        manaHtml: ''
    }

    initialize: ()=>
        return @
