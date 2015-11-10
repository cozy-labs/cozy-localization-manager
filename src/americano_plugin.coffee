# Factory to make an americano plugin. The plugin will initialize the singleton
# before the application starts.
module.exports = (singleton) -> (options, app, callback) ->
    root = if typeof options is 'string' then options else options.root
    singleton.initialize localePath: "#{root}/server/locales/", callback
