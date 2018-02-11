{ attackTypes } = require '../constants'
{ random, err, warn } = require '../general'

prefixes =
    superior:
        name: 'superior'
        description: '10% increased damage'
        minLevel: 0
        probability: 8
        costMultiplier: 1.2
        apply: (weapon) ->
            weapon.min *= 1.1
            weapon.max *= 1.1
            return weapon
    exceptional:
        name: 'exceptional'
        description: '20% increased damage'
        minLevel: 10
        probability: 4
        costMultiplier: 1.5
        apply: (weapon) ->
            weapon.min *= 1.2
            weapon.max *= 1.2
            return weapon
    elite:
        name: 'elite'
        description: '30% increased damage'
        minLevel: 20
        probability: 2
        costMultiplier: 2.0
        apply: (weapon) ->
            weapon.min *= 1.3
            weapon.max *= 1.3
            return weapon
    longRange:
        name: 'long range'
        description: '+2 increased range'
        minLevel: 0
        probability: 8
        exclusive: attackTypes.ranged
        costMultiplier: 1.5
        apply: (weapon) ->
            weapon.range += 2
            return weapon
    marksmans:
        name: 'marksman\'s'
        description: '+5 increased range'
        minLevel: 10
        probability: 4
        exclusive: attackTypes.ranged
        costMultiplier: 2
        apply: (weapon) ->
            weapon.range += 5
            return weapon
    apprentices:
        name: 'apprentice\'s'
        description: '-10% mana cost for spells'
        minLevel: 10
        probability: 8
        exclusive: attackTypes.magic
        costMultiplier: 2
        apply: (weapon) ->
            weapon.manaAdjustment *= 0.9
            return weapon
    acolytes:
        name: 'acolytes\'s'
        description: '-25% mana cost for spells'
        minLevel: 20
        probability: 4
        exclusive: attackTypes.magic
        costMultiplier: 3
        apply: (weapon) ->
            weapon.manaAdjustment *= 0.75
            return weapon

getRandomPrefix = (weapon, hero) ->
    result = null
    available = (prefix for key, prefix of prefixes when prefix.minLevel <= hero.level and (not prefix.exclusive or prefix.exclusive is hero.weapon.attackType))
    num = random()
    for prefix in available
        if num < prefix.probability
            result = prefix
            break
        else
            num -= prefix.probability
    if result
        newWeapon = Object.assign {}, weapon, { prefix: result, cost: weapon.cost * result.costMultiplier }
        return result.apply newWeapon

    return weapon

module.exports =
    getRandomPrefix: getRandomPrefix
