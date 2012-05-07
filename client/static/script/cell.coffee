''' ========================================================================    
    cell.coffee

    Contains the definition for individual cells that make up the map 
    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Cell')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    View

    ======================================================================== '''
class GAME_NAME.Views.Cell extends Backbone.View
    events: {
        'mouseenter': 'mouseEnter'
        'mouseleave': 'mouseLeave'
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
        
        #Store reference to passed in vars
        @cellSize = @options.cellSize
        @group = @options.group

        #Create the element (but don't add it yet)
        @x = @model.get('i') * @cellSize.width
        @y = @model.get('j') * @cellSize.height

        #Set el as an empty element, we'll create it in render()
        @el = {}

        return @

    render: ()=>
        #Draw the map cell
        el = @group.append('svg:rect')
            .attr('class', 'map_tile tile_' + @x + ',' + @y)
            .attr('x', @x)
            .attr('y', @y)
            .attr('width', @options.cellSize.width)
            .attr('height', @options.cellSize.height)
        @el = el.node()

        #Setup events, using the events listed above
        @delegateEvents()

    mouseEnter: ()=>
        d3.select(@el).style('fill', '#6699cc')
    mouseLeave: ()=>
        d3.select(@el).style('fill', '#336699')

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Cell extends Backbone.Model
    defaults: {
        #Default properties
        name: 'cell_i,j'

        type: '0'

        #Graphic contains the image to use for this cell
        graphic: ''
    }

    initialize: ()=>
        return @
