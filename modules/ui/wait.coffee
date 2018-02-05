{ log, err } = require '../general'
{ states } = require '../constants'

outputter = (state, hero, map) ->
    log '* press any key to continue *'
    return

mutator = (state, input, hero, map) ->
    return [ true, { state: state.param }, hero, map ]

register = (processors, outputProcessors) ->
    return [ [processors..., { state: states.wait, fn: mutator }], [outputProcessors..., { state: states.wait, fn: outputter }] ]

module.exports =
    register: register
