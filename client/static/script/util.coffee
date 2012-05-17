''' ========================================================================    
    creature.coffee

    Contains the class definitions for creatures

    ======================================================================== '''
''' ========================================================================    
    Add logging types
    ======================================================================== '''
#Add a log type
GAME_NAME.logger.options.log_types.push('Util')
#Add it as a log type
GAME_NAME.logger.options.setup_log_types()

''' ========================================================================    
    
    Utils

    ======================================================================== '''
GAME_NAME.util = (()=>
    delegateSVGEvents = (e)->
        console.log(e)
    

   
    return {
        delegateSVGEvents: delegateSVGEvents
    }
)()
