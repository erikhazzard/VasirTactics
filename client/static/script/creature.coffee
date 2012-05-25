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

        #Store reference to passed in vars
        @game = @options.game
        @map = @options.game.get('map')
        @renderer = @options.game.get('renderer')
        @cellSize = @renderer.model.get('cellSize')
        @group = @options.group
        @interaction = GAME_NAME.game.get('interaction')

        #Listen for events
        #--------------------------------
        @model.on('creature:targeted', @target)
        @model.on('change:location', @update)
        @model.on('change:location', @target)
        @model.on('change:movesLeft', @target)
        @model.on('change:movesLeft', ()=>
            #Only do this if this creature is the selected
            #   one
            if @model.belongsToActivePlayer() and @model == @interaction.get('target')
                @interaction.set({
                    targetHtml: @targetHtml()
                })
        )
        @model.on('spell:cast', @handleSpell)
        
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

        #Animate the movement with transition
        @svgEl.transition()
            .duration(900)
            .attr('transform', 'translate(' + [@x,@y] + ')')

    #------------------------------------
    #
    #Events - User Interaction
    #
    #------------------------------------
    #Note: events are triggered on the game's interaction model
    creatureClicked: ()=>
        '''Fired off when the user clicks on a creature'''

        #If this creature is already targeted, we want to 
        #   fire off an event to set the target to null
        if @interaction.get('target') == @model
            @interaction.set({
                target: undefined
            })
        else
            #This creature isn't already targeted, so target it
            @interaction.set({
                target: @model
                targetHtml: @targetHtml()
            })

        return @

    #------------------------------------
    #
    #Target / Untarget
    #
    #------------------------------------
    target: ()=>
        #Targets this creature.  Updates the game map and
        #   darkens the immovable map cells

        #If this creature doesn't belong to the active player, don't 
        #   allow them to move the creature
        #Also, don't do this if this creature isn't the target
        #TODO: MAKE SURE THIS WORKS
        if not @model.belongsToActivePlayer() or @model != @interaction.get('target')
            return @
            
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

        #Renable cells
        mapCells = @map.get('cells')
        for cell in legitCells
            #Turns off the tile_disabled class
            mapCells[cell.get('x') + ',' + cell.get('y')].trigger(
                'cell:enableCell'
            )

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

    #------------------------------------
    #UI Functions
    #------------------------------------
    targetHtml: ()=>
        #Returns HTML to be put in the target box. Uses the target
        #   box template
        html = ''

        #If this creature doesn't to the currently active player,
        #   do different logic
        if @model.belongsToActivePlayer()
            #This creature belongs to the active player, so show all stats
            html = _.template(GAME_NAME.templates.target_creature_mine)({
                name: @model.get('name'),
                health: @model.get('health')
                movesLeft: @model.get('movesLeft')
            })
        else
            #They target an opponent
            html = _.template(GAME_NAME.templates.target_creature_theirs)({
                name: @model.get('name'),
                health: @model.get('health')
            })

        return html

    #------------------------------------
    #Game Functions
    #------------------------------------
    handleSpell: (params)=>
        #Called when a spell is casted on this creature,
        #   called from the spell:cast event
        console.log('spell cast!')
        #make sure the spell is passed in
        params = params || {}
        if not params.spell
            visually.logger.error('creature:handleSpell():',
                'no spell passed into handleSpell',
                'params: ', params)

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
        passType: 'ground'

        #Owner is the player which controls this creature
        owner: undefined
    }

    #------------------------------------
    #Init
    #------------------------------------
    initialize: ()=>
        #Listen for events
        @on('creature:move', @move)

        return @

    #------------------------------------
    #
    #util / game functions
    #
    #------------------------------------
    #Helper utils
    belongsToActivePlayer: ()=>
        #returns the index of this creature in the active player's creature collection
        index = GAME_NAME.game.get('activePlayer').get('creatures').indexOf(@)
        if index > -1
            return true
        else
            return false

    target: ()=>
        #When target() is called, trigger the cell:targeted event
        #   The view will listen for this event
        @trigger('creature:targeted')
        return @

    #------------------------------------
    #Move Calculations
    #------------------------------------
    calculateMovementCells:(params)=>
        #Finds legit cells that this creature can move to
        #   Returns an array of legit cells
        #TODO: Put in web worker
        
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
                    if @canMove({cell: curCell})
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
            return false

        #TODO: Do this a better way - check Map class instead of cell state
        #   CAN MOVE function
        if @calculateMovementCells().indexOf(cell) < 0
            return @

        #If this creature doesn't belong to the active player, we can't move it
        if not @belongsToActivePlayer()
            return @

        #Update the moves left
        #   Since we're moving diagonal, we just need to take the greater of
        #   x or y and lower the movesleft by it
        #TODO: make this work
        deltaX = Math.abs(@get('location').x - cell.get('x'))
        deltaY = Math.abs(@get('location').y - cell.get('y'))
        if deltaX > deltaY
            deltaMoves = deltaX
        else
            deltaMoves = deltaY

        #Set the moves left
        movesLeft = @get('movesLeft') - deltaMoves

        #Move the creature
        #   When the location changes, the view's update() function is called
        @set({
            location: {
                x: cell.get('x'),
                y: cell.get('y')
            },
            movesLeft: movesLeft
        })

        return @

    canMove:(params)=>
        #Takes in a cell and returns true / false if the creature
        #   can move to it
        params = params || {}
        cell = params.cell
        if not cell
            GAME_NAME.logger.error('creature model: move(): no cell passed into params')
        ableToMove = false

        #Pass checks
        if cell.get('canPass') == 'all' or cell.get('canPass') == @get('passType')
            ableToMove = true
        else
            ableToMove = false

        return ableToMove

''' ========================================================================    
    
    Colections

    ======================================================================== '''
class GAME_NAME.Collections.Creatures extends Backbone.Collection
    model: GAME_NAME.Models.Creature
