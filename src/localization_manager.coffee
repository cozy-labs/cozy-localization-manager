cozydb = require 'cozydb'
path = require 'path'
Polyglot = require 'node-polyglot'
logger = require('printit')(prefix: 'localization')

# Localization Manager that initializes and wraps Polyglot to allow server-side
# localization.
module.exports = class LocalizationManager

    DEFAULT_LOCALE: 'en'

    polyglot: null
    defaultPolyglot: null

    # Must be called before the app starts.
    initialize: (options = {}, callback = ->) ->
        logger.info "Initialize Localization Manager."

        @localePath = options.localePath or '../locales/'

        @_retrieveLocale (err, locale) =>
            try
                @_buildPolyglotObject locale
                logger.info "Localization Manager successfully initialized."
                callback()
            catch err
                logger.error "A fatal error occured during initialization " + \
                             "of Localization Manager, all translation " + \
                             "will be empty."
                callback err


    # Used internally to retrieve locale that is going to be used.
    # Check database, fallback to a default value if necessary.
    _retrieveLocale: (callback) ->
        logger.info 'Retrieve locale from database.'
        cozydb.api.getCozyLocale (err, locale) ->
            if err? or not locale?
                logger.info "Locale not found, use default locale instead " + \
                            "(#{@DEFAULT_LOCALE})."
                locale = @DEFAULT_LOCALE

                if err?
                    logger.error 'The following error could explain why:'
                    logger.raw err
            else
                logger.info "Locale '#{locale}' found."

            callback err, locale


    # Helper to build path to locale's phrases.
    _getPathForLocale: (locale) ->
        return path.resolve(@localePath, locale)


    # Build polyglot objects: one for the default locale (used as fallback), and
    # one for the current locale.
    _buildPolyglotObject: (locale) ->

        # Get phrases for default locale.
        defaultLocalePath = @_getPathForLocale(@DEFAULT_LOCALE)
        try
            defaultPhrases = require defaultLocalePath
        catch err
            logger.error "Could not load phrases for default locale in " + \
                         "'#{defaultLocalePath}'."
            logger.error err
            throw err

        # Get phrases for current locale.
        try
            phrases = require @_getPathForLocale(locale)
        catch err
            logger.error "Could not load phrases for locale '#{locale}', " + \
                         "use phrases from default locale " + \
                         "(#{@DEFAULT_LOCALE}) instead."
            phrases = defaultPhrases
            locale = @DEFAULT_LOCALE

        # Build the polyglot object for current locale.
        @polyglot = new Polyglot
            locale: locale
            phrases: phrases

        # Build the polyglot object anyway in order to fallback if the
        # translation is not found for current locale.
        @defaultPolyglot  = new Polyglot
            locale: @DEFAULT_LOCALE
            phrases: defaultPhrases


    # Wrapper for `polyglot.t`. Use default locale as fallback if the
    # translation key is not found for current locale.
    t: (key, params = {}) ->

        if @polyglot?
            # If it has not been defined, automatically add fallback
            # translation.
            params._ ?= @defaultPolyglot?.t key, params
            return @polyglot?.t key, params

        else
            logger.error 'Cannot translate because polyglot objects have ' + \
                         'not been built.'
            return ''


    # Must be called when the CozyInstance document has changed.
    realtimeCallback: -> @initialize()
