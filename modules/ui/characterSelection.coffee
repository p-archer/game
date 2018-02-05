{ log, err, random } = require '../general'
{ heroClass, states, MAP_SIZE } = require '../constants'

Point = require '../point'
Hero = require '../hero.coffee'
Map = require '../map'

initGame = (hc) ->
    hero = Hero.create { position: new Point(random(MAP_SIZE), random(MAP_SIZE)), heroClass: hc, skillPoints: 10 }
    map = new Map hero

    return [ hero, map ]

outputter = (state, hero, map) ->
    console.clear()
    log()
    log ' --- character selection --- '
    log '1\twarrior (melee weapons)'
    log '2\tarcher (ranged weapons)'
    log '3\tmage (magic weapons and spells)'

    return

mutator = (state, input, hero, map) ->
    hc = null
    switch input
        when '1' then hc = heroClass.warrior
        when '2' then hc = heroClass.archer
        when '3' then hc = heroClass.mage
        when 'q'
            log 'bye'
            process.exit 0

    if hc
        [ hero, map ] = initGame hc
        return [ true, { state: states.normal, param: 'firstTime' }, hero, map ]

    return [ false, state, hero, map ]

register = (processors, outputProcessors) ->
    return [ [processors..., { state: states.characterSelection, fn: mutator }], [outputProcessors..., { state: states.characterSelection, fn: outputter }] ]

module.exports =
    register: register
