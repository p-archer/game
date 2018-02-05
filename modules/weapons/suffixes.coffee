{ attackTypes, heroStates } = require '../constants'
{ random, err } = require '../general'

suffixes =
    bleeding:
        name: 'bleeding'
        description: '5% chance to cause bleeding'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 5 then return [ weaponStates.bleeding ]
    wounding:
        name: 'wounding'
        description: '10% chance to cause bleeding'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 10 then return [ weaponStates.bleeding ]
    blood:
        name: 'blood'
        description: '20% chance to cause bleeding'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 20 then return [ weaponStates.bleeding ]
    piercing:
        name: 'piercing'
        description: '10% chance to ignore armour'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 10 then return [ weaponStates.piercing ]
    armourPiercing:
        name: 'armour piercing'
        description: '20% chance to ignore armour'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 20 then return [ weaponStates.piercing ]
    armourPenetration:
        name: 'armour penetration'
        description: '40% chance to ignore armour'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.ranged]
        apply: () ->
            if random() < 40 then return [ weaponStates.piercing ]
    poison:
        name: 'poison'
        description: '10% chance to poison enemy'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        apply: () ->
            if random() < 10 then return [ weaponStates.poisoning ]
    venom:
        name: 'venom'
        description: '20% chance to poison enemy'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        apply: () ->
            if random() < 20 then return [ weaponStates.poisoning ]
    plague:
        name: 'plague'
        description: '40% chance to poison enemy'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        apply: () ->
            if random() < 40 then return [ weaponStates.poisoning ]
    maiming:
        name: 'maiming'
        description: '5% chance to maim enemy'
        minLevel: 0
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 5 then return [ weaponStates.maiming ]
    mayhem:
        name: 'mayhem'
        description: '10% chance to maim enemy'
        minLevel: 15
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            if random() < 10 then return [ weaponStates.maiming ]
    leech:
        name: 'the leech'
        description: '10% life steal'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            return [ weaponStates.leeching ]
    vampire:
        name: 'the vampire'
        description: '25% life steal'
        minLevel: 25
        probability: 2
        costMultiplier: 3
        exclusive: [attackTypes.melee, attackTypes.ranged]
        apply: () ->
            return [ weaponStates.leeching, weaponStates.leeching ]
    burning:
        name: 'burning'
        description: '2.5% chance to immolate enemy'
        minLevel: 0
        probability: 8
        costMultiplier: 1.5
        apply: () ->
            if random(1000) < 25 then return [ weaponStates.burning ]
    fire:
        name: 'fire'
        description: '5% chance to immolate enemy'
        minLevel: 10
        probability: 4
        costMultiplier: 2
        apply: () ->
            if random() < 5 then return [ weaponStates.burning ]
    scorching:
        name: 'scorching'
        description: '10% chance to immolate enemy'
        minLevel: 20
        probability: 2
        costMultiplier: 3
        apply: () ->
            if random() < 10 then return [ weaponStates.burning ]
    imp:
        name: 'the imp'
        description: '10% mana steal'
        minLevel: 5
        probability: 8
        costMultiplier: 2
        exclusive: [attackTypes.magic]
        apply: () ->
            return [ weaponStates.manaLeeching ]
    efrit:
        name: 'the efrit'
        description: '25% mana steal'
        minLevel: 20
        probability: 4
        costMultiplier: 3.0
        exclusive: [attackTypes.magic]
        apply: () ->
            return [ weaponStates.manaLeeching, weaponStates.manaLeeching ]

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
        weapon.suffix = result
        weapon.cost *= result.costMultiplier
    return weapon

module.exports =
    getRandomSuffix: getRandomSuffix
