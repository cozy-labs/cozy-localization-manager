chai = require 'chai'
chai.should()
sinon = require 'sinon'

LocalizationManager = require '../src/localization_manager'
pluginFactory = require '../src/americano_plugin'


describe 'Americano Plugin', ->

    describe 'Plugin factory', ->

        before ->
            @manager = new LocalizationManager()
            @sandbox = sinon.sandbox.create()
            @initialize = @sandbox.stub(@manager, 'initialize')
            @initialize.callsArgAsync 1

        after ->
            @sandbox.restore()

        it 'should return a function', ->
            @plugin = pluginFactory(@manager)
            @plugin.should.be.a('function')

        it 'the function should initialize the singleton', (done) ->
            options = root: __dirname
            @plugin options, {}, =>
                @initialize.callCount.should.equal 1
                @initialize.calledOnce.should.be.ok
                done()


    describe 'Plugin used by an americano server', ->

        it 'When an americano server starts'
        it 'The localization manager should be initialized'
