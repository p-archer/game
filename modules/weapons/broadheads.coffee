{ random, err, log, warn, getPercent } = require '../general'
{ heroStates, weaponStates, XP_GAIN_FACTOR } = require '../constants'
chalk = require 'chalk'

broadheads =
    bleeding:
        name: 'lacerating broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for bleeding'
        range: 1.1
        damage: 0.85
        chance: 10
        use: () -> if random() < @chance then return [ { effect: heroStates.bleeding, ticks: 3 } ] else return []
        unlocks: () -> if @level is 4 then return [ broadheads.vampiric ] else return []
    burning:
        name: 'flaming broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for burning'
        range: 0.65
        damage: 1
        chance: 10
        use: () -> if random() < @chance then return [ { effect: heroStates.burning, ticks: 3 } ] else return []
        unlocks: () -> if @level is 4 then return [ broadheads.freezing ] else return []
    freezing:
        name: 'freezing broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for freezing'
        range: 1
        damage: 0.5
        chance: 10
        use: () -> if random() < @chance then return [ { effect: heroStates.frozen, ticks: 1 } ] else return []
        unlocks: () -> []
    heavy:
        name: 'heavy broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for critical'
        range: 0.7
        damage: 1.2
        chance: 0
        use: () -> if random() < @chance then return [ { effect: weaponStates.critical, ticks: 1} ] else return []
        unlocks: () -> if @level is 2 then return [ broadheads.piercing ] else return []
    light:
        name: 'light broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for critical'
        range: 1.1
        damage: 0.85
        chance: 0
        use: () -> if random() < @chance then return [ { effect: weaponStates.critical, ticks: 1} ] else return []
        unlocks: () -> if @level is 2 then return [ broadheads.poisoning ] else return []
    normal:
        name: 'normal broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for critical'
        range: 1
        damage: 1
        chance: 0
        use: () -> if random() < @chance then return [ { effect: weaponStates.critical, ticks: 1} ] else return []
        unlocks: () ->
            if @level is 2 then return [ broadheads.light, broadheads.heavy ] else return []
            if @level is 4 then return [ broadheads.burning ] else return []
    piercing:
        name: 'piercing broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for piercing'
        range: 0.85
        damage: 1
        chance: 20
        use: () -> if random() < @chance then return [ { effect: weaponStates.piercing, ticks: 1} ] else return []
        unlocks: () -> []
    poisoning:
        name: 'poisoned broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +' + @chance + '% chance for poisoning'
        range: 1.2
        damage: 0.75
        chance: 10
        use: () -> if random() < @chance then return [ { effect: heroStates.poisoned, ticks: 3 } ] else return []
        unlocks: () -> if @level is 2 then return [ broadheads.bleeding ] else return []
    vampiric:
        name: 'vampiric broadhead'
        description: () -> getPercent(@damage) + ' damage, ' + getPercent(@range) + ' range, +10% life steal'
        range: 0.9
        damage: 0.9
        chance: 0
        use: () -> return [ { effect: weaponStates.leeching, ticks: 1} ]
        unlocks: () -> return []

create = (item) ->
    broadhead =
        chance: item.chance
        damage: item.damage
        description: item.description
        key: item.key
        level: item.level || 0
        levelUp: item.levelUp
        name: item.name
        nextLevel: item.nextLevel || 25
        range: item.range
        unlocks: item.unlocks
        use: item.use
        xp: item.xp || 0

    return Object.freeze broadhead

getAll = () ->
    return broadheads

gainXP = (list, index, xp) ->
    broadhead = Object.assign {}, list[index], { xp: list[index].xp + xp }
    while broadhead.xp >= broadhead.nextLevel
        broadhead = Object.assign {}, broadhead.levelUp(), { level: broadhead.level+1, xp: broadhead.xp - broadhead.nextLevel }

    unlocks = broadhead.unlocks()
    unlocks = unlocks.filter (x) ->
        return list.filter((y) -> return x.key is y.key).length is 0
    if unlocks.length > 0
        log chalk.green '# you have unlocked: ' + (unlocks.map((x) -> x.name)).join ', '
        unlocks = unlocks.map (x) -> return create x
        return [ list[0...index]..., create(broadhead), list[index+1...]..., unlocks... ]

    return [ list[0...index]..., create(broadhead), list[index+1...]... ]

init = () ->
    for key, broadhead of broadheads
        broadhead.key = key
        broadhead.levelUp = () -> return Object.assign {}, this, { chance: @chance + 1 }

init()

module.exports =
    create: create
    gainXP: gainXP
    getAll: getAll
