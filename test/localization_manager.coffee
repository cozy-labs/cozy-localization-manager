chai = require 'chai'
should = chai.should()
sinon = require 'sinon'

LocalizationManager = require '../src/localization_manager'

describe 'Localization Manager', ->

    describe '_getPathForLocale', ->
        before ->
            @manager = new LocalizationManager()

        it 'should return a full path', ->
            @manager.localePath = __dirname
            path = @manager._getPathForLocale 'en'
            path.should.equal "#{__dirname}/en"

    describe '_buildPolyglotObject', ->
        describe 'Current locale phrases are found', ->
            before ->
                @manager = new LocalizationManager()
                @manager.localePath = "#{__dirname}/fixtures/locales"
                @manager._buildPolyglotObject('fr')

            it 'should build a polyglot object based on current locale', ->
                should.exist(@manager.polyglot)
                @manager.polyglot.currentLocale.should.equal 'fr'

            it 'should build a polyglot object based on default locale', ->
                should.exist(@manager.defaultPolyglot)
                @manager.defaultPolyglot.currentLocale.should.equal 'en'

        describe 'Current locale phrases are not found', ->
            before ->
                @manager = new LocalizationManager()
                @manager.localePath = "#{__dirname}/fixtures/locales"
                @manager._buildPolyglotObject('de')

            it 'should build two polyglot objects based default locale', ->
                should.exist(@manager.polyglot)
                @manager.polyglot.currentLocale.should.equal 'en'
                should.exist(@manager.defaultPolyglot)
                @manager.defaultPolyglot.currentLocale.should.equal 'en'

        describe 'Default locale phrases are not found', ->
            before ->
                @manager = new LocalizationManager()
                @manager.localePath = "#{__dirname}/fixtures/not_found"

            it 'should throw', ->
                func = @manager._buildPolyglotObject.bind(@manager, 'fr')
                should.throw(func)

    describe 't', ->
        describe 'Phrases have been found', ->
            before ->
                @manager = new LocalizationManager()
                @manager.localePath = "#{__dirname}/fixtures/locales"
                @manager._buildPolyglotObject('fr')

            it 'should return the translation', ->
                @manager.t('hello').should.equal('Salut')

            it 'should return the translation for default locale if key is not found for current locale', ->
                @manager.t('goodbye').should.equal('Goodbye')

        describe 'Phrases have not been found', ->
            before ->
                @manager = new LocalizationManager()
                @manager.localePath = "#{__dirname}/fixtures/not_found"
                try
                    @manager._buildPolyglotObject('fr')

            it 'should return an empty string', ->
                @manager.t('hello').should.equal('')

    describe 'realtimeCallback', ->
        before ->
            @manager = new LocalizationManager()
            @sandbox = sinon.sandbox.create()
            @initialize = @sandbox.stub(@manager, 'initialize')

        after ->
            @sandbox.restore()

        it 'should reinitialize the manager', ->
            @manager.realtimeCallback.call(@manager)
            @initialize.callCount.should.equal(1)

    describe '_retrieveLocale', ->

        describe 'Database call is ok', ->
            before ->
                @manager = new LocalizationManager()
                @sandbox = sinon.sandbox.create()
                @databaseCall = @sandbox.stub require('cozydb').api, 'getCozyLocale'
                @databaseCall.callsArgWithAsync 0, null, 'fr'

            after ->
                @sandbox.restore()

            it 'should return the locale', (done) ->
                @manager._retrieveLocale (err, locale) ->
                    should.not.exist(err)
                    should.exist(locale)
                    locale.should.equal 'fr'
                    done()

        describe 'Database call is not ok', ->
            before ->
                @manager = new LocalizationManager()
                @sandbox = sinon.sandbox.create()
                @databaseCall = @sandbox.stub require('cozydb').api, 'getCozyLocale'
                @databaseCall.callsArgWithAsync 0, 'error', null

            after ->
                @sandbox.restore()

            it.skip 'should return the default locale', (done) ->
                @manager._retrieveLocale (err, locale) ->
                    should.not.exist(err)
                    should.exist(locale)
                    locale.should.equal 'en'
                    done()

    describe 'initialize', ->
        before ->
            @manager = new LocalizationManager()
            @sandbox = sinon.sandbox.create()
            @databaseCall = @sandbox.stub require('cozydb').api, 'getCozyLocale'
            @databaseCall.callsArgWithAsync 0, null, 'fr'

        after ->
            @sandbox.restore()

        it 'should let the manager in a state ready to translate', (done) ->
            options = localePath: "#{__dirname}/fixtures/locales"
            @manager.initialize options, =>
                @manager.t('hello').should.equal('Salut')
                done()



