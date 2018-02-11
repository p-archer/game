{ attackTypes, heroStates, weaponStates } = require '../constants'
{ random, err } = require '../general'

suffixes =
    bleeding:
        name: 'bleeding'
        description: '10% chance to cause bleeding (bleeds for 3 rounds)'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 10 then return [ { effect: heroStates.bleeding, ticks: 3} ] else return []
    wounding:
        name: 'wounding'
        description: '20% chance to cause bleeding (bleeds for 1 round)'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 20 then return [ { effect: heroStates.bleeding, ticks: 1} ] else return []
    blood:
        name: 'blood'
        description: '20% chance to cause bleeding (bleeds for 3 rounds)'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 20 then return [ { effect: weaponStates.bleeding, ticks: 3} ] else return []
    piercing:
        name: 'piercing'
        description: '10% chance to ignore armour'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 10 then return [ { effect: weaponStates.piercing, ticks: 1} ] else return []
    armourPiercing:
        name: 'armour piercing'
        description: '20% chance to ignore armour'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 20 then return [ { effect: weaponStates.piercing, ticks: 1} ] else return []
    armourPenetration:
        name: 'armour penetration'
        description: '40% chance to ignore armour'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 40 then return [ { effect: weaponStates.piercing, ticks: 1} ] else return []
    poison:
        name: 'poison'
        description: '10% chance to poison enemy'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        apply: () ->
            if random() < 10 then return [ { effect: heroStates.poisoned, ticks: 3} ] else return []
    venom:
        name: 'venom'
        description: '20% chance to poison enemy'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        apply: () ->
            if random() < 20 then return [ { effect: heroStates.poisoned, ticks: 3} ] else return []
    plague:
        name: 'plague'
        description: '40% chance to poison enemy'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        apply: () ->
            if random() < 40 then return [ { effect: heroStates.poisoned, ticks: 3} ] else return []
    maiming:
        name: 'maiming'
        description: '5% chance to maim enemy'
        minLevel: 0
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 5 then return [ { effect: heroStates.maimed, ticks: 1} ] else return []
    mayhem:
        name: 'mayhem'
        description: '10% chance to maim enemy'
        minLevel: 15
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 10 then return [ { effect: heroStates.maimed, ticks: 1} ] else return []
    leech:
        name: 'the leech'
        description: '10% life steal'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            return [ { effect: weaponStates.leeching, ticks: 1} ]
    vampire:
        name: 'the vampire'
        description: '20% life steal'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            return [ { effect: weaponStates.leeching, ticks: 1}, { effect: weaponStates.leeching, ticks: 1} ]
    burning:
        name: 'burning'
        description: '10% chance to immolate enemy (burns for 3 rounds)'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        apply: () ->
            if random(100) < 10 then return [ { effect: heroStates.burning, ticks: 3} ] else return []
    fire:
        name: 'fire'
        description: '20% chance to immolate enemy (burns for 1 rounds)'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        apply: () ->
            if random() < 20 then return [ { effect: heroStates.burning, ticks: 2} ] else return []
    scorching:
        name: 'scorching'
        description: '20% chance to immolate enemy (burns for 3 rounds)'
        minLevel: 20
        probability: 2
        costMultiplier: 3
        apply: () ->
            if random() < 20 then return [ { effect: heroStates.burning, ticks: 1} ] else return []
    imp:
        name: 'the imp'
        description: '10% mana steal'
        minLevel: 5
        probability: 8
        costMultiplier: 2
        exclusive: [attackTypes.magic]
        apply: () ->
            return [ { effect: weaponStates.manaLeeching, ticks: 1} ]
    efrit:
        name: 'the efrit'
        description: '20% mana steal'
        minLevel: 20
        probability: 4
        costMultiplier: 3.0
        exclusive: [attackTypes.magic]
        apply: () ->
            return [ { effect: weaponStates.manaLeeching, ticks: 1}, { effect: weaponStates.manaLeeching, ticks: 1} ]

getRandomSuffix = (weapon, hero) ->
    result = null
    available = (suffix for own key, suffix of suffixes when suffix.minLevel <= hero.level and (not suffix.exclusive or suffix.exclusive.has(hero.weapon.attackType)))
    num = random()
    for suffix in available
        if num < suffix.probability
            result = suffix
            break
        else
            num -= suffix.probability
    if result
        return Object.assign {}, weapon, { suffix: result, cost: weapon.cost * result.costMultiplier }
    return weapon

module.exports =
    getRandomSuffix: getRandomSuffix
