''' ========================================================================    
    interaction.coffee

    Cotains the game's Interface.  The interaction controls all user interaciton
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
    '''Renders the interaction and handles firing off / listening for events'''

    initialize: ()=>
        #Setup events to listen on
        @model = @options.model

        #Setup events
        @model.on('change:target', @target)
        @model.on('change:targetHtml', @renderTarget)

        #TODO: turn this into a view
        $('#game_actions_wrapper .next_move').click(@nextMove)

        #Store refs to dom nodes
        @$targetEl = $('#game_target_wrapper .game_target')

    render: ()=>
        #Render the UI
        return @

    #------------------------------------
    #
    #Next move
    #
    #------------------------------------
    nextMove: ()=>
        #Next turn, do stuff
        #TODO!!!!!!!!!!!!!!!!!!!!!
        #Fire off some global next turn event which all models will
        #   listen for (on the game model)
        creatures = GAME_NAME.game.get('activePlayer').get('creatures').models
        for creature in creatures
            creature.set({
                'movesLeft': creature.get('moves')
            }, {silent: true})

        #Clear out the target
        @model.set({
            target: undefined
        })

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
            @model.set({targetHtml: ''})
            
    unTargetTiles: ()=>
        #Remove any classes added when creatures get targeted
        d3.select('.map_tile_selected')
            .classed('map_tile_selected', false)

        #Reneable all map tiles
        d3.selectAll('.tile_disabled')
            .classed('tile_disabled', false)

    renderTarget: (params)=>
        #Updates the target box UI HTML
        @$targetEl.html(@model.get('targetHtml'))

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Interface extends Backbone.Model
    defaults: {
        target: undefined
        targetHtml: ''
    }

    initialize: ()=>
        return @
