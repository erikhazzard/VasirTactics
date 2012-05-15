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
        @on('event:name', @someFunc)

    render: ()=>
        #Render the UI
        return @

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Interface extends Backbone.Model
    defaults: {}
