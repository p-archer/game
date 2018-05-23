{ random, err, log, warn, getPercent } = require '../general'
{ attackTypes, heroStates, weaponStates, XP_GAIN_FACTOR } = require '../constants'
chalk = require 'chalk'

BROADHEAD_NEXTLEVEL = 25

elementalLevelUp = (broadhead) ->
    result = Object.assign {}, broadhead
    if Math.floor(result.damage[0].ratio * 100) > 0
        result.damage[0].ratio -= 0.05
        result.damage[1].ratio += 0.05
    else
        result.chance = Math.min result.chance + 1, 100
    return result

broadheads =
    burning:
        name: 'fire'
        range: 0.9
        damage: [ { ratio: 0.5, type: attackTypes.physical }, { ratio: 0.5, type: attackTypes.fire } ]
        chance: 10
        effects: [ { effect: heroStates.burning, name: 'burning', ticks: 3 } ]
        unlocks: () -> if @level is 2 then return [ broadheads.ice ] else return []
        levelUp: () -> return elementalLevelUp @
    ice:
        name: 'ice'
        range: 0.9
        damage: [ { ratio: 0.5, type: attackTypes.physical }, { ratio: 0.5, type: attackTypes.ice } ]
        chance: 10
        effects: [ { effect: heroStates.frozen, name: 'freezing', ticks: 10 } ]
        unlocks: () -> if @level is 2 then return [ broadheads.lightning ] else return []
        levelUp: () -> return elementalLevelUp @
    lightning:
        name: 'lightning'
        range: 1
        damage: [ { ratio: 0.5, type: attackTypes.physical }, { ratio: 0.5, type: attackTypes.lightning } ]
        chance: 0
        effects: [ { effect: weaponStates.critical, name: 'critical hit', ticks: 1 } ]
        unlocks: () -> if @level is 2 then return [ broadheads.dark ] else return []
        levelUp: () -> return elementalLevelUp @
    dark:
        name: 'dark'
        range: 1
        damage: [ { ratio: 0.50, type: attackTypes.physical }, { ratio: 0.50, type: attackTypes.dark } ]
        chance: 0
        effects: [ { effect: weaponStates.critical, name: 'critical hit', ticks: 1} ]
        unlocks: () -> return []
        levelUp: () -> return elementalLevelUp @
    poisoning:
        name: 'poisoned'
        range: 0.9
        damage: [ { ratio: 0.5, type: attackTypes.physical }, { ratio: 0.5, type: attackTypes.poison } ]
        chance: 20
        effects: [ { effect: heroStates.poisoned, name: 'poisoning', ticks: 3 } ]
        unlocks: () -> if @level is 2 then return [ broadheads.bleeding ] else return []
        levelUp: () -> return elementalLevelUp @

    bleeding:
        name: 'lacerating'
        range: 1.1
        damage: [ { ratio: 0.85, type: attackTypes.physical } ]
        chance: 20
        effects: [ { effect: heroStates.bleeding, name: 'bleeding', ticks: 3 } ]
        unlocks: () -> if @level is 4 then return [ broadheads.vampiric ] else return []
    heavy:
        name: 'heavy'
        range: 0.7
        damage: [ { ratio: 1.2, type: attackTypes.physical } ]
        chance: 0
        effects: [ { effect: weaponStates.critical, name: 'critical hit', ticks: 1} ]
        unlocks: () -> if @level is 2 then return [ broadheads.piercing ] else return []
    light:
        name: 'light'
        range: 1.1
        damage: [ { ratio: 0.85, type: attackTypes.physical } ]
        chance: 0
        effects: [ { effect: weaponStates.critical, name: 'critical hit', ticks: 1} ]
        unlocks: () -> if @level is 2 then return [ broadheads.poisoning ] else return []
    normal:
        name: 'normal'
        range: 1
        damage: [ { ratio: 1, type: attackTypes.physical } ]
        chance: 0
        effects: [ { effect: weaponStates.critical, name: 'critical hit', ticks: 1} ]
        unlocks: () ->
            if @level is 2 then return [ broadheads.light, broadheads.heavy ]
            if @level is 4 then return [ broadheads.burning ]
            return []
    piercing:
        name: 'piercing'
        range: 0.85
        damage: [ { ratio: 0.5, type: attackTypes.physical }, { ratio: 0.5, type: attackTypes.pure } ]
        chance: 0
        effects: [ { effect: weaponStates.critical, name: 'critical hit', ticks: 1} ]
        unlocks: () -> if @level is 2 then return [ broadheads.vampiric ] else return []
    vampiric:
        name: 'vampiric'
        range: 0.9
        damage: [ { ratio: 0.90, type: attackTypes.physical } ]
        chance: 100
        effects: [ { effect: weaponStates.leeching, name: 'leeching', ticks: 1} ]
        unlocks: () -> if @level is 2 then return [ broadheads.dark ] else return []

create = (item) ->
    broadhead =
        chance: item.chance
        damage: item.damage
        description: item.description
        effects: item.effects
        key: item.key
        level: item.level || 0
        levelUp: item.levelUp
        name: item.name
        nextLevel: BROADHEAD_NEXTLEVEL
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
        log chalk.cyan '# you have unlocked: ' + (unlocks.map((x) -> x.name)).join(', ') + ' broadheads/spearheads'
        unlocks = unlocks.map (x) -> return create x
        return [ list[0...index]..., create(broadhead), list[index+1...]..., unlocks... ]

    return [ list[0...index]..., create(broadhead), list[index+1...]... ]

init = () ->
    for key, broadhead of broadheads
        broadhead.key = key
        if not broadhead.levelUp then broadhead.levelUp = () -> return Object.assign {}, this, { chance: Math.min(@chance + 1, 100) }
        broadhead.description = () ->
            effects = ', +' + @chance + '% for ' + @effects[0].name # TODO not the most elegant solution
            damages = []
            for entry in @damage
                damages.push (entry.ratio*100).toFixed(0) + '% ' + entry.type
            return damages.join(', ') + ' damage, ' + getPercent(@range) + ' range' + effects
        broadhead.use = (incoming) ->
            damage = []
            effects = if random(10000) < @chance * 100 then @effects else []
            for entry in @damage
                damage.push { amount: entry.ratio * incoming, type: entry.type }
            return [ damage, effects ]
init()

module.exports =
    create: create
    gainXP: gainXP
    getAll: getAll
