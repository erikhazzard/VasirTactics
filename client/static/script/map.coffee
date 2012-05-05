''' ========================================================================    
    map.coffee

    Contains the definition for map, which is retrieved from server and made
    up of cells.  A Map object is made up of map cells and the Map
    is owned by the Game object

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Map')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Map extends Backbone.Model
    defaults: {
        #Default properties
        name: 'Faydwer'

        #map_array is the raw map json returned from the server
        #   Each cell is formatted lie [ [{}, {}], [{}, {}] ] 
        #   (example of a 2x2 grid). The contents of each cell
        #   returned from the server represent a cell's parameters,
        #   which get passed into the Cell class.
        map_array: [
            [ {type: 0}, {type: 0} ],
            [ {type: 0}, {type: 0} ]
        ]
        #Cells
        #   Cells contains a dictionary of cell objects, keys being 
        #   i,j. e.g.,
        #       cells['0,4'] = [Cell Object]
        cells: {}
    }

    initialize: ()=>
        setupCells({cells:@map_array})
        return @

    setupCells: (params)=>
        '''Setup the game cells.  This is called from init and
            the cells are setup based on this model's map array
            Takes in a array of cells '''
        #Setup params
        params = params || {}
        params.cells = params.cells || []

        #Loop through cells
        for cell in params.cells
            #create a new Cell object for each cell
            GAME_NAME.logger.Map('cell: ', cell)
