''' ========================================================================    
    renderer.coffee

    Handles the actual drawing / rendering of the game

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Render')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    

    Renderer

    ======================================================================== '''
class GAME_NAME.Views.Renderer extends Backbone.View
    el: '#canvas_game'

    #------------------------------------
    #Events
    #------------------------------------
    events: {}

    #------------------------------------
    #
    #Functions
    #
    #------------------------------------
    #TODO: Remove @d3El, use some other thing instead
    initialize: ()=>
        '''Create the renderer view.  This should be called from game.js'''
        #Game must be passed in from options
        if @options.game == undefined
            GAME_NAME.logger.error('ERROR! renderer view: options.game not set, pass in game!')
            return false

        #Create Renderer model
        @model = new GAME_NAME.Models.Renderer({
            game: @options.game
        })

        #Setup this element
        @d3El = d3.select('#game_canvas')

        return @

    #------------------------------------
    #UI Renderer
    #------------------------------------
    renderUI: ()=>
        #TODO: Break this out into peices, call render() of each view
        #Update player list
        #------------------
        players = @model.get('game').get('players')
        activePlayer = @model.get('game').get('activePlayer')

        list_html = []
        for key, player of players
            list_html.push('<li>' + player.get(
                'name') + ': ' + player.get(
                'health') + 'HP </li>')
        
        #Update player list
        $('#game_player_info_wrapper .player_list').html(list_html.join(''))

        #Update spells
        #-------------
        spells_html = []
        #TODO: Put in collection
        for key, spell of activePlayer.get('spells')
            #Create a view for each spell
            spellView = new GAME_NAME.Views.Spell({
                model: spell
            }).render()

        return @

    #------------------------------------
    #
    #Game Render
    #
    #------------------------------------
    render: ()=>
        '''This draws all the elements of the game to the screen'''
        #Remove everything in the SVG
        $(@d3El.node()).empty()

        #Draw the background map
        @drawMap({
            map: @model.get('game').get('map')
        })
    
        #Draw each player's creatures
        @drawCreatures()

        return @

    drawCreatures: ()=>
        '''Draw all the creatures for each player'''
        #Create the group which will hold the creature 
        @creaturesGroup = @d3El.append('svg:g')
            .attr('class', 'creatures_group')
        
        #For each player, draw their creatures
        players = @model.get('game').get('players')
        for key, player of players
            #Get all creatures for each player
            creatures = player.get('creatures')

            #Render each creature
            for creature in creatures.models
                do (creature)=>
                    @drawCreature({
                        creature: creature
                        group: @creaturesGroup
                    })

        #TODO: Draw creatures, entities, etc. based on game state
        return @
        
    #------------------------------------
    #draw map
    #------------------------------------
    drawMap: (map)=>
        '''This draws the map by rendering each map tile individually'''
        #TODO: Some sort of caching?
        #TODO: Abstract this out?
        
        #Create the map group
        @mapGroup = @d3El.append('svg:g')
            .attr('class', 'game_map')
        mapTileGroup = @mapGroup.append('svg:g')
            .attr('class', 'map_tiles')

        #TODO: Abstract this into Map.render?
        #Loop through each cell of the map and draw it
        cells = @model.get('game').get('map').get('cells')
        for key, val of cells
            cell = new GAME_NAME.Views.Cell({
                model: val
                cellSize: @model.get('cellSize')
                group: mapTileGroup
            })
            
            #Draw it
            cell.render({renderer: @model})

        #Notify the logger we're finished
        GAME_NAME.logger.Render('renderer: map rendering complete')

    #------------------------------------
    #draw creature 
    #------------------------------------
    drawCreature: (params)=>
        '''Draws the passed in entity on the screen. Params expects a
        creature model to be passed in'''
        #Params should take in a Creature model
        params = params || {}
        if params.creature == undefined or params.group == undefined
            GAME_NAME.logger.error('ERROR! renderer view: drawCreature(): creature not passed in')
            return false

        #Create new view for the passed in creature model
        if not params.creature.get('view')
            params.creature.set({'view': new GAME_NAME.Views.Creature({
                model: params.creature,
                game: @model.get('game'),
                group: params.group
                })
            })

        #Render the passed in creature
        params.creature.get('view').render({
            renderer: @,
            group: params.group
        })

        #Finished!
        return @


''' ========================================================================    

    Model

    ======================================================================== '''
class GAME_NAME.Models.Renderer extends Backbone.Model
    '''Keeps track of the renderer state'''

    #TODO: Pre load all images
    defaults: {

        #--------------------------------
        #Map Related
        #--------------------------------
        cellSize: {
            height: 48,
            width: 48
        },
        #--------------------------------
        #Sprites
        #--------------------------------
        sprites: {
            #Terrain / map
            'terrain_0': '/static/image/sprites/map/grass_bg.png',
            'terrain_1': '/static/image/sprites/map/blue_grass.jpg'
            'terrain_2': '/static/image/sprites/map/road.jpg'

            #Obstacles
            'rock': '/static/image/sprites/map/rock.png'

            #Characters
            'creature_dragoon': '/static/image/sprites/creatures/dragoon.png'
        }

    }

    #------------------------------------
    #
    #Functions
    #
    #------------------------------------
    initialize: ()=>
        '''When this renderer model is instaniated, store a reference to the
        game object'''

        return @
