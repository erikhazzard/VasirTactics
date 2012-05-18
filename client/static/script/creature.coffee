''' ========================================================================    
    creature.coffee

    Contains the class definitions for creatures

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Creature')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    VIEW 

    ======================================================================== '''
class GAME_NAME.Views.Creature extends Backbone.View
    events: {
        'click': 'creatureClicked'
    }

    initialize: ()=>
        '''This creature view is created in Renderer'''
        #It must pass in the associated model, cellSize, and target
        #   group to render to
        if @options.model == undefined or @options.game == undefined or @options.group == undefined
            GAME_NAME.logger.error('ERROR', 'creature view init(): params not properly passed in')
            return false

        #Set the model
        @model = @options.model
        @model.on('change:location', @update)

        #Store reference to passed in vars
        @game = @options.game
        @map = @options.game.get('map')
        @renderer = @options.game.get('renderer')
        @cellSize = @renderer.model.get('cellSize')
        @group = @options.group
        @interface = GAME_NAME.game.get('interface')
        
        #Set el as an empty element, we'll create it in render()
        @el = {}

        return @

    #------------------------------------
    #util / helper
    #------------------------------------
    delegateSVGEvents: ()=>
        #Use d3.on to set events
        for key, val of @events
            @svgEl.on(key, @[val])

        return @

    #------------------------------------
    #
    #Render
    #
    #------------------------------------
    render: (params)=>
        '''Handles the actual rendering / drawing of the creature'''

        #Get x,y of creature
        @x = @model.get('location').x * @cellSize.width
        @y = @model.get('location').y * @cellSize.height

        #When using SVG we only need to draw the entity once
        #The mapGroup will be set from drawMap
        creature_group = @group.append('svg:g')
            .attr('class', 'creature_' + @model.cid)
            .attr('transform', 'translate(' + [@x,@y] + ')')

        #Draw the background rect 
        bg_rect = creature_group.append('svg:rect')
            .attr('class', 'creature_background_rect')
            .attr('x', 0)
            .attr('y', 0)
            .attr('rx', 6)
            .attr('ry', 6)
            .attr('width', @cellSize.width)
            .attr('height', @cellSize.height)

        #Draw the creature image
        creature_group.append('svg:image')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @cellSize.width)
            .attr('height', @cellSize.height)
            .attr('xlink:href', @renderer.model.get('sprites')[@model.get('sprite')])

        #Store ref to DOM node
        @el = creature_group.node()
        #Store ref to d3 selection 
        @svgEl = creature_group
        #Setup events, using the events listed above
        @delegateSVGEvents()

        return @

    #------------------------------------
    #update
    #------------------------------------
    update: ()=>
        #Function called to update the position / etc.
        @x = @model.get('location').x * @cellSize.width
        @y = @model.get('location').y * @cellSize.height
        @svgEl.attr('transform', 'translate(' + [@x,@y] + ')')

    #------------------------------------
    #
    #Events - User Interaction
    #
    #------------------------------------
    #Note: events are triggered on the game's interface model
    creatureClicked: ()=>
        '''Fired off when the user clicks on a creature'''

        #If this creature is already targeted, we want to 
        #   fire off an event to set the target to null
        if @interface.get('target') == @model
            @interface.set({
                target: undefined
            })
        else
            #This creature isn't already targeted, so target it
            @interface.set({
                target: @model
            })

        return @

    #------------------------------------
    #Target / Untarget
    #------------------------------------
    target: ()=>
        '''Targets this creature.  Updates the UI and
            darkens the immovable map cells'''

        #Store i and j
        creature_i = @model.get('location').x
        creature_j = @model.get('location').y

        #Remove the map_tile_selected class from all elements that
        #   have it
        selectedEls = d3.selectAll('.map_tile_selected')
            .classed('map_tile_selected', false)

        #Darken all the map cells
        mapTiles = d3.selectAll('.map_tile')
            .classed('tile_disabled', true)

        #Highlight the map cells that the creature can move to
        #TODO: Put this in web worker
        #TODO: Code the real logic for this, not just this fake stub
        legitCells = @model.calculateMovementCells()
        mapCells = @map.get('cells')
        for cell in legitCells
            cell = mapCells[cell.get('x') + ',' + cell.get('y')].get('view').svgEl
            cell.classed('tile_disabled', false)

        #Highlight this creature's background rect
        rect = @svgEl.select('rect')
        rect.classed('map_tile_selected', true)
        return @

    mouseEnter: ()=>
        rect = @svgEl.select('rect')
        rect.classed('map_tile_mouse_over', true)
        return @

    mouseLeave: ()=>
        #TODO: Fix this
        rect = @svgEl.select('rect')
        rect.classed('map_tile_mouse_over', false)
        return @

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Creature extends Backbone.Model
    defaults: {
        name: 'Toestubber'
        className: 'creature'

        attack: 1,
        health: 1,
        
        #current target will point to a creature or player object
        target: {},

        #Effects contains effects this creature has
        effects: []

        #Abilities are activated or passive things this creature has
        abilities: []

        #How far creature can move
        moves: 3
        #How many cells are left to move after creature is moved
        #   (In case creature is removed)
        movesLeft: 3
        
        #Position properties
        #   Stores x,y
        location: {
            x: Math.round(Math.random() * 5),
            y: Math.round(Math.random() * 5)
        }

        #Sprite
        sprite: 'creature_dragoon',
            
        #Type could be either 'ground' or 'air' for now
        type: 'ground'

        #Associated view
        view: undefined
    }

    initialize: ()=>
        return @

    #------------------------------------
    #
    #util / game functions
    #
    #------------------------------------
    #Helper utils
    target: ()=>
        return @get('view').target()

    #------------------------------------
    #Move Calculations
    #------------------------------------
    calculateMovementCells:(params)=>
        #Finds legit cells that this creature can move to
        #   Returns an array of legit cells
        #params can be empty OR cells can be passed in
        
        params = params || {}
        #Get all game cells
        cells = params.cells || GAME_NAME.game.get('map').get('cells')

        #Keep an array of possible movement cells
        movementCells = []
        
        #Get cells around this creature
        creatureLocation = @get('location')
        movesLeft = @get('movesLeft')

        loopLen = movesLeft
        rangeLen = -movesLeft

        #Start at the top left and get all the cells that extend in a square to
        #   the length of the moves
        for i in [rangeLen..loopLen]
            for j in [rangeLen..loopLen]
                curCell = cells[ (creatureLocation.x + i) + ',' + (creatureLocation.y + j) ]
                #Make sure the cell we're looking at exists
                if curCell != undefined
                    #Make sure the cell isn't impassable
                    #TODO: IMRPOVE
                    if curCell.get('canPass') == 'all' || curCell.get(
                        'canPass') == @get('type')
                        #Get all movable adjacent cells
                        movementCells.push(
                            curCell
                        )

        return movementCells
        
       
    #------------------------------------
    #Movement related
    #------------------------------------
    move: (params)=>
        #Attemps to move the creature to target cell
        #Params expects a cell object to move to
        params = params || {}
        cell = params.cell
        if not cell
            GAME_NAME.logger.error('creature model: move(): no cell passed into params')

        #Move the creature
        #   When the location changes, the view's update() function is called
        @set({
            location: {
                x: cell.get('x'),
                y: cell.get('y')
            }
        })

    canMove:(params)=>
        #Takes in a cell and returns true / false if the creature
        #   can move to it
        params = params || {}
        cell = params.cell
        if not cell
            GAME_NAME.logger.error('creature model: move(): no cell passed into params')

        return true
