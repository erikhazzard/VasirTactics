''' ========================================================================    
    spells.coffee

    Contains the class definitions spells
        Spells instaniated from server

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Spells')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    Model    

    ======================================================================== '''
class GAME_NAME.Models.Spells extends Backbone.Model
    defaults: {
        name: 'Magic Missle'

        #current target will (usually) point to a creature or player object
        target: {},

        effect: ()=>
            #this is a callback returned from the server which will do 
            #   something to the target
            return @
    }

    initialize: ()=>
        return @
