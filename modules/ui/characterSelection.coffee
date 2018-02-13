{ log, err, random } = require '../general'
{ heroClass, states, MAP_SIZE } = require '../constants'

Point = require '../point'
Hero = require '../hero.coffee'
Map = require '../map'
Abilities = require '../abilities/abilities.coffee'
abilities = Abilities.getNames()
Skills = require '../skills/skills.coffee'

initGame = (hc) ->
    hero = Hero.create {
        position: new Point(random(MAP_SIZE), random(MAP_SIZE))
        heroClass: hc
        level: 1
        # skillPoints: 10
        # gold: 100000
        # abilities: [ Abilities.getAll()[abilities.manaDrain.key] ]
    }
    # hero = Hero.buySkill hero, Object.assign {}, Skills.getAll().tactics, { key: 'tactics' }
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
