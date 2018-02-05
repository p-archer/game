{ log, err } = require '../general'
{ states } = require '../constants'

state = require '../state'
main = require './main.coffee'
quit = require './quit.coffee'
characterSelection = require './characterSelection.coffee'
characterSheet = require './characterSheet.coffee'
combat = require './combat/main.coffee'
wait = require './wait.coffee'
shop = require './shop.coffee'

outputProcessors = []
processors = []

use = (processor, state, input, hero, map) ->
    if processor.state is state.state
        return processor.fn state, input, hero, map
    return [ false, state, hero, map ]

showOutput = (state, hero, map) ->
    for outputProcessor in outputProcessors
        if outputProcessor.state is state.state
            outputProcessor.fn state, hero, map
    return

handleInput = (state, input, hero, map) ->
    if input is '\u0003'
        log 'bye'
        process.exit 0

    for processor in processors
        [ handled, rest... ] = use processor, state, input, hero, map
        if handled then return [ true, rest... ]

    return [false, state, hero, map]

init = () ->
    [ processors, outputProcessors ] = main.register processors, outputProcessors
    [ processors, outputProcessors ] = quit.register processors, outputProcessors
    [ processors, outputProcessors ] = characterSelection.register processors, outputProcessors
    [ processors, outputProcessors ] = characterSheet.register processors, outputProcessors
    [ processors, outputProcessors ] = combat.register processors, outputProcessors
    [ processors, outputProcessors ] = wait.register processors, outputProcessors
    [ processors, outputProcessors ] = shop.register processors, outputProcessors

init()

module.exports =
    handleInput: handleInput
    showOutput: showOutput
