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
        # mastery:
            # level: 10
        # abilities: [ Abilities.getAll()[abilities.manaDrain.key] ]
    }
    # hero = Hero.buySkill hero, Object.assign {}, Skills.getAll().tactics, { key: 'tactics' }
    hero.skills.inspection.level = 5
    map = new Map hero

    return [ hero, map ]

outputter = (state, hero, map) ->
    console.clear()
    log()
    log ' --- character selection --- '
    log '1\twarrior (axes)'
    log '2\tcrusader (hammers)'
    log '3\tknight (swords)'
    log '4\tarcher (bows)'
    log '5\tarbalist (crossbows)'
    log '6\tbandit (spears)'
    log '7\tmage (staffs)'
    log '8\tsorcerer (tomes)'
    log '9\twizard (wands)'
    return

mutator = (state, input, hero, map) ->
    hc = null
    switch input
        when '1' then hc = heroClass.warrior
        when '2' then hc = heroClass.crusader
        when '3' then hc = heroClass.knight
        when '4' then hc = heroClass.archer
        when '5' then hc = heroClass.arbalist
        when '6' then hc = heroClass.bandit
        when '7' then hc = heroClass.mage
        when '8' then hc = heroClass.sorcerer
        when '9' then hc = heroClass.wizard
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
