{ log, err, getPercent } = require '../general'
{ XP_GAIN_FACTOR } = require '../constants'
chalk = require 'chalk'

# maybe level scaling might be a good idea
arrows =
    normal:
        name: 'standard'
        range: 1
        damage: 1
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return if @level is 2 then [arrows.light, arrows.heavy] else []
    light:
        name: 'light'
        range: 1.1
        damage: 0.9
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return if @level is 2 then [arrows.elven] else []
    heavy:
        name: 'heavy'
        range: 0.9
        damage: 1.1
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return if @level is 2 then [arrows.orcish] else []
    elven:
        name: 'elven'
        range: 1.2
        damage: 0.95
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return if @level is 2 then [arrows.sniper] else []
    orcish:
        name: 'orcish'
        range: 0.9
        damage: 1.2
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return if @level is 2 then [arrows.iron] else []
    sniper:
        name: 'sniper'
        range: 1.5
        damage: 0.8
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return []
    iron:
        name: 'iron'
        range: 0.8
        damage: 1.5
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range'
        unlocks: () -> return []

create = (item) ->
    arrow =
        damage: item.damage
        description: item.description
        key: item.key
        level: item.level || 0
        levelUp: item.levelUp
        name: item.name
        nextLevel: item.nextLevel || 25
        range: item.range
        unlocks: item.unlocks
        xp: item.xp || 0

    return Object.freeze arrow

getAll = () ->
    return arrows

gainXP = (quiver, index, xp) ->
    arrow = Object.assign {}, quiver[index], { xp: quiver[index].xp + xp }
    while arrow.xp >= arrow.nextLevel
        arrow = Object.assign {}, arrow.levelUp(), { level: arrow.level+1, xp: arrow.xp - arrow.nextLevel }

    unlocks = arrow.unlocks()
    unlocks = unlocks.filter (x) ->
        return quiver.filter((y) -> return x.key is y.key).length is 0
    if unlocks.length > 0
        log chalk.cyan '# you have unlocked: ' + (unlocks.map((x) -> x.name)).join(', ') + ' arrows/shafts'
        unlocks = unlocks.map (x) -> return create x
        return [ quiver[0...index]..., create(arrow), quiver[index+1...]..., unlocks... ]

    return [ quiver[0...index]..., create(arrow), quiver[index+1...]... ]

init = () ->
    for key, arrow of arrows
        arrow.key = key
        arrow.levelUp = () -> return Object.assign {}, this, { range: @range + 0.01, damage: @damage + 0.01 }

init()

module.exports =
    create: create
    gainXP: gainXP
    getAll: getAll
