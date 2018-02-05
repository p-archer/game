{ log, err, warn } = require '../general'
{ directions, states } = require '../constants'
Hero = require '../hero.coffee'

interact = (state, hero, map) ->
    level = map.current

    # prev level
    if level.start.isSame hero.position
        if map.current.parent?
            map.current = map.current.parent
            return [ { state: states.normal }, hero, map ]
        warn '> you can\'t go back any further'
        return [ state, hero, map ]

    # next level
    if end = level.isEnd hero.position
        if not end.children?
            end.children = map.generateNewLevel hero, (level.end[1] and level.end[1].position.isSame(end.position))
        map.current = end.children
        return [ { state: states.normal }, hero, map ]

    # monster
    if level.isMonster hero.position then return [{ state: states.combat.main }, Hero.create(Object.assign({}, hero, { combatPos: 10 })), map ]

    # chest
    if level.isTreasure hero.position then return [ state, openTreasure(hero, map)... ]

    # shop
    if level.isShop hero.position then return [ { state: states.shop }, hero, map ]

    return [state, hero, map]

outputter = (state, hero, map) ->
    if state.param?
        log ''
        log 'movement\t\t w, a, s, d'
        log 'interact\t\t e'
        log ''
        log 'character menu\t c'
        log 'quit\t\t\t q'

    map.show hero
    map.current.showCellData hero
    return

mutator = (state, input, hero, map) ->
    switch input
        when 'q' then return [ true, { state: states.quit }, hero, map ]
        when 'c' then return [ true, { state: states.characterSheet.main }, hero, map ]
        when 'a' then return [ true, { state: states.normal }, Hero.move(hero, map.current, directions.west), map ]
        when 'd' then return [ true, { state: states.normal }, Hero.move(hero, map.current, directions.east), map ]
        when 'w' then return [ true, { state: states.normal }, Hero.move(hero, map.current, directions.north), map ]
        when 's' then return [ true, { state: states.normal }, Hero.move(hero, map.current, directions.south), map ]
        when 'e'
            return [ true, interact(state, hero, map)... ]
    return [ false, state, hero, map ]

register = (processors, outputProcessors) ->
    return [ [processors..., { state: states.normal, fn: mutator }], [outputProcessors..., { state: states.normal, fn: outputter}] ]

module.exports =
    register: register
