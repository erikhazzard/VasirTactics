''' ========================================================================    
    
    Logging System
        
    ======================================================================== '''
#NOTE: We can access all the history of each logger type by calling
#   logger.history (will show a dict of all log types and their 
#   history)
logger = window.GAME_NAME.logger

#----------------------------------------
#Options
#----------------------------------------
#log_level can be 'none' or null (in which case nothing will get logged)
#   or a specific log type (e.g., 'error' or 'debug')
#   or an array of log types (e.g., ['error', 'warn'] )
#   or it can be set to 'all' or true (for EVERYTHING) 
logger.options = {
    log_level: 'all'
    #log_level: 'info'
    #log_level: ['error', 'warn']
    #log_level: 'all'
}

#----------------------------------------
#History
#----------------------------------------
#The history will be updated when logger.log() is called
#   the keys are the log type (e.g., 'warn') and the value
#   is the arguments passed to the log function
logger.history = {}

#----------------------------------------
#Log methods
#----------------------------------------
logger.can_log = (type)->
    '''This function takes in a type (e.g., 'warn') and checks to see if
    it exists in the logger.options.log_level option
    '''
    return_value = false
    #Store local reference (saves time and is faster)
    log_level = logger.options.log_level

    if log_level == 'all' or log_level == true
        #If they want everything, give it to them
        return_value = true
    else if log_level instanceof Array
        if log_level.indexOf(type) > -1
            #If indexOf(type) returns anything greater than -1, it means we
            #   found this tpye in the log_level
            return_value = true
    else if (log_level == null or log_level == undefined or log_level == 'none' or log_level == false)
        #Make sure log_level isn't null, 'none', or undefined
        return_value = false
    else
        #If we get here, it means log level is just a string
        #If log level is just a string, check the type to it
        if log_level == type
            return_value = true

    #Return it
    return return_value

#----------------------------------------
#Log() function
#----------------------------------------
logger.log = (type)->
    '''
        When using logger.log, you must pass in a type
        e.g.
            logger.debug( arg1, arg2, etc. )
    '''
    #Because the first argument might not exist, we'll need to
    #   create a copy of arguments and make the type the first
    #   parameter if it's not passed in
    args = Array.prototype.slice.call(arguments)

    #Check for passed in type
    if not type? or arguments.length == 1
        #If they don't pass in a type, assume debug
        #OR if they only passed in one argument (if they didn't pass in a type,
        #   just a message)
        type = 'debug'
        #We don't want the first argument to be undefined
        args.splice(0, 0, 'debug')

    #Check to see if we can log
    if not logger.can_log(type)
        return false

    #Add some meta info to the log call
    cur_date = new Date()
    args.push({
        'Date': cur_date
        'Milliseconds': cur_date.getMilliseconds()
        'Time': cur_date.getTime()
    })

    #Keep track of all log messages
    log_history = logger.history
    log_history[type] = log_history[type] || []

    #Add message to history
    log_history[type].push(args)

    #Make sure console exists
    if window.console
        #Call console.log, pass in an array which we iterate through using
        #   the passed in arguments (This better ensures nicer console output
        #   in firefox / chrome rather than simply just passing in the 
        #   arguments array (use Array instead of [] so we don't instantiate
        #   an Array object)
        console.log(Array.prototype.slice.call(args))

    return true

#Setup specific logger types.  We could extend these to do more stuff later
#   We can also add any arbitrary log type we want either
#To add a type, just add it to array here
logger.options.log_types = [
    'debug', 'error', 'info', 'warn'
]

logger.options.setup_log_types = ()->
    '''This function will setup log types based on the ones available in
    logger.options.log_types.  It can be called whenever to 
    dynamically add log types
    '''
    for log_type in logger.options.log_types
        #Wrap this in a closure
        do (log_type) ->
            #Create a logger[log_type] function for each different log type
            logger[log_type] = ()->
                #Store all arguments
                args = Array.prototype.slice.call(arguments)
                #Add the log_type as the first argument
                args.splice(0, 0, log_type)
                #Call and return the log() function, passing in log_type
                #   as the first parameter
                return logger.log.apply(null,args)
#call it
logger.options.setup_log_types()

''' ========================================================================    
    Configure console.log
    ======================================================================== '''
#----------------------------------------
#Configure window.console.log
#----------------------------------------
#Set the window.console.log function to visually.log
if window.console and logger.options
    #If log_errors is false, don't log errors
    if logger.options.log_level == 'none' or logger.options.log_level is null
        console.log = ()-> {}

#If window.console does not exist, create an empty log function
if not window.console?
    window.console = {
        log: ()-> {}
    }

#Catch and handle all general exceptions
window.onerror = (msg, url, line)->
    logger.error(msg, url, line)
    return false
