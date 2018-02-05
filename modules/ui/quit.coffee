{ log, err } = require '../general'
{ states } = require '../constants'

outputter = (state, hero, map) ->
    log '> are you sure you want to quit?'
    return

mutator = (state, input, hero, map) ->
    switch input
        when 'y'
            log 'bye'
            process.exit 0
        when 'n', 'q'
            return [ true, null, hero, map ]
    return [ false, state, hero, map ]

register = (processors, outputProcessors) ->
    return [ [processors..., { state: states.quit, fn: mutator }], [outputProcessors..., { state: states.quit, fn: outputter }] ]

module.exports =
    register: register
