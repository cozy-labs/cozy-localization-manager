LocalizationManager = require './template_localization_manager'
americanoPluginFactory = require './americano_plugin'

singleton = new LocalizationManager()
module.exports =

    # Export a singleton to facilitate usage
    getInstance: -> return singleton

    # Called during americano's initialization, when used as a plugin.
    configure: americanoPluginFactory(singleton)
