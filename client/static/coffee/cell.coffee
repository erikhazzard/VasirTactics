# ============================================================================
# cell.coffee
#
# Contains the definition for individual cells that make up the map 
# ============================================================================
# ============================================================================
# Add logging types
# ============================================================================
#Add a log type
GAME_NAME.logger.options.log_types.push('Cell')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

# ============================================================================
#    
#    View
#
# ============================================================================
class GAME_NAME.Views.Cell extends Backbone.View
    events: {
        'click': 'click'
        'mouseover': 'mouseEnter'
        'mouseout': 'mouseLeave'
    }

    initialize: ()=>
        '''This cell view is created in Renderer'''
        #It must pass in the associated model, cellSize, and target
        #   group to render to
        if @options.model == undefined or @options.cellSize == undefined or @options.group == undefined
            GAME_NAME.logger.error('ERROR', 'cell view: params not properly passed in')
            return false

        #Create a model
        @model = @options.model

        #Listen for events
        #--------------------------------
        @model.on('cell:targeted', @target)
        @model.on('cell:enableCell', @enableCell)
        @model.on('spell:cast', @handleSpell)
        
        #Store reference to passed in vars
        @cellSize = @options.cellSize
        @group = @options.group

        #Create the element (but don't add it yet)
        @x = @model.get('x') * @cellSize.width
        @y = @model.get('y') * @cellSize.height
        @userInterface = GAME_NAME.game.get('userInterface')

        #Set el as an empty element, we'll create it in render()
        @el = {}

        return @

    #------------------------------------
    #util / helper
    #------------------------------------
    delegateSVGEvents: ()=>
        #Use d3.on to set events
        for key, val of @events
            @d3El.on(key, @[val])

        return @

    #------------------------------------
    #
    #render
    #
    #------------------------------------
    render: (params)=>
        #Render creates the map tile cells and the group containing them
        #   Expects a renderer model object to be passed in
        params = params || {}
        if params.renderer == undefined
            GAME_NAME.logger.error('ERROR', 'cell render(): renderer not passed in')
            return false

        #TODO: Abstract this out so we can render individual cells
        
        #Draw the map cell
        #--------------------------------
        cellGroup = @group.append('svg:g')
            .attr('class', 'cellGroup cellGroup_' + @x + ',' + @y)
            .attr('transform', 'translate(' + [@x, @y] + ')')

        #--------------------------------
        #Draw the graphic
        #--------------------------------
        @baseSprite = cellGroup.append('svg:image')
            .attr('class', 'map_tile_image')
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)
            .attr('xlink:href', params.renderer.get('sprites')[@model.get('baseSprite')])

        #If there is an overlay or top sprite on top of the base sprite
        if @model.get('topSprite')
            @topSprite = cellGroup.append('svg:image')
                .attr('class', 'map_tile_image_overlay')
                .attr('x', 0)
                .attr('y', 0)
                .attr('width', @options.cellSize.width)
                .attr('height', @options.cellSize.height)
                .attr('xlink:href', params.renderer.get('sprites')[@model.get('topSprite')])

        #Draw the rect / el
        #--------------------------------
        #el and @el will be the background rect (it may be invisible), which will take up
        #   100% width and height of the cell
        @cellRect = cellGroup.append('svg:rect')
            .attr('class', 'map_tile tile_' + @x + ',' + @y)
            .attr('x', 0)
            .attr('y', 0)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)

        #Store ref to DOM node
        @el = cellGroup.node()
        #Store ref to d3 selection 
        @d3El = cellGroup
        #Setup events, using the events listed above
        @delegateSVGEvents()

    #------------------------------------
    #Cell events
    #------------------------------------
    enableCell: ()=>
        #Turns off the tile_disabled class
        @cellRect.classed('tile_disabled', false)
        #Enable the cell
        @model.set({'cellEnabled': true})

    click: ()=>
        #Called when the cell:clicked event is triggered
        #TODO: Make this more event driven, so we don't need to handle
        #   creature move logic checks here? Could maybe move the
        #   creauture move stuff to the creature class, listen on events
        #TODO: Need to unit the shit out of this
        
        #TODO: (7/4) - Need to come up with concept of different selection
        #   modes (cell selection, unit selection, attack selection, etc.)
        #   Store this selection mode in the user interface, do logic there
        #See if we can target the cell or creature
        canSetInterfaceTarget = false
        moveCreature = false

        #TODO-------------------
        #Target mode
        console.log(@userInterface.get('targetMode'))

        #Do checks
        #   Breaking on multiple lines to make it easier to follow
        if not @userInterface.get('target')
            canSetInterfaceTarget = true

        #Check based on target
        if @userInterface.get('target')
            #We can switch to a new target if the existing on was a cell
            if @userInterface.get('target').get('className') == 'cell'
                canSetInterfaceTarget = true

            if @userInterface.get('target') == @model or not @model.get('cellEnabled')
                #TODO: make this work when targeting cells that don't have the 
                #   tile_disabled class (when all cells are enabled and you
                #   click on a cell, that cell should have cellEnabled
                #   as true. It does not right now.)
                
                #If the target is the currently targeted cell, untarget it
                #OR, if the cell is disabled, untarget the current target
                canSetInterfaceTarget = false
                @userInterface.set({ target: undefined })

            else if @userInterface.get('target').get('className') == 'creature'
                if not @userInterface.get('target').belongsToActivePlayer()
                    #If no creature is targeted already or an oppnent creature is 
                    #   targeteted, we can straight up target the cell
                    canSetInterfaceTarget = true
                else
                    canSetInterfaceTarget = false
                    moveCreature = true

        #Set the game interface target if we can
        if canSetInterfaceTarget
            @userInterface.set({
                target: @model
                targetHtml: @targetHtml()
            })

        #OTHERWISE, we need to do special logic
        if moveCreature
            #If a creature is already targeted, we need to do special logic
            #   e.g., move
            @userInterface.get('target').trigger('creature:move', {
                cell: @model
            })

        
        return canSetInterfaceTarget

    target: ()=>
        #Called when user clicks on a cell
        #Highlight this creature's background rect
        rect = @d3El.select('rect')
        rect.classed('map_tile_selected', true)
        return @

    mouseEnter: ()=>
        @cellRect.classed('map_tile_mouse_over', true)
        return @

    mouseLeave: ()=>
        @cellRect.classed('map_tile_mouse_over', false)
        return @

    #------------------------------------
    #UI Helper functions
    #------------------------------------
    targetHtml: ()=>
        #Renders the target box
        html = _.template(GAME_NAME.templates.target_cell)({
            model: @model
        })
        return html

    #------------------------------------
    #Spell handling
    #------------------------------------
    handleSpell: (params)=>
        #Called when a spell is casted on this creature,
        #   called from the spell:cast event
        #make sure the spell is passed in
        params = params || {}
        if not params.spell
            visually.logger.error('cell:handleSpell():',
                'no spell passed into handleSpell',
                'params: ', params)

        #Call the spell effect
        params.spell.get('effect')({target: @d3El, model: @model})

        return @

# ============================================================================
#    
# Model
#
# ============================================================================
class GAME_NAME.Models.Cell extends Backbone.Model
    defaults: {
        #Default properties
        name: 'cell_i,j'
        className: 'cell'

        #Position of cell
        x: 0
        y: 0

        baseSprite: ''
        topSprite: ''

        type: '0'

        #Graphic contains the image to use for this cell
        graphic: ''

        #Determines if the cell is enabled or not
        cellEnabled: false
    }

    initialize: ()=>
        return @

    target: ()=>
        #When target() is called, trigger the cell:targeted event
        #   The view will listen for this event
        @trigger('cell:targeted')
        return @
