# Description

Localization is a key point for application adoption. At Cozy Cloud, we use Polyglot, but developers still have to deal with stuff like getting user's locale from database. The LocalizationManager will help you manage localization on the server.

It's simple as an [americano](https://github.com/cozy/americano) plugin.

# Usage

## Initialization
### Americano plugin
In server/config.{js|coffee}:
```coffeescript
    plugins: [
        'cozy-localization-manager'
        'cozydb'
    ]
```

### Manually
Before the server start, run:
```coffeescript
manager = require('cozy-localization-manager').getInstance()
options =
    localePath: 'path/to/your/locales/folder'
manager.initialize options, (err) ->
    manager.t('translate all the things !')
```

## Translation
Whenever you need to translate something:

```coffeescript
manager = require('cozy-localization-manager').getInstance()
manager.t('localization key')
```

That's it!

## Locales path
If you use the library as an americano plugin, you need to have your locale files in server/locales/.
Each file must match the locale name. For instance: en.json, fr.json, de.json.

## Polyglot
You can find everything about Polyglot (locales format, options) in their [documentation](http://airbnb.io/polyglot.js/).


# Development

Clone this repository, install dependencies and run server (it requires Node.js)

    git clone git://github.com/cozy-labs/cozy-localization-manager.git
    cd cozy-localization-manager
    npm install
    npm run dev


# What is Cozy?

![Cozy Logo](https://raw.github.com/cozy/cozy-setup/gh-pages/assets/images/happycloud.png)

[Cozy](http://cozy.io) is a platform that brings all your web services in the
same private space.  With it, your web apps and your devices can share data
easily, providing you
with a new experience. You can install Cozy on your own hardware where no one
profiles you. You install only the applications you want. You can build your
own one too.

## Community

You can reach the Cozy community via various channels:

* IRC #cozycloud on irc.freenode.net
* Post on our [Forum](https://forum.cozy.io/)
* Post issues on the [Github repos](https://github.com/cozy/)
* [Twitter](http://twitter.com/mycozycloud)
