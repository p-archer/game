{ log, err, random } = require '../general'
{ attackTypes, heroStates, states } = require '../constants'

getNames = () ->
    names = {}
    for own key, value of abilities
        names[key] = { key: key, name: value.name }
    return names

abilities =
    powerShot:
        name: 'power shot'
        attackType: attackTypes.ranged
        mana: 5
        description: '+100% damage to a normal attack. (No retaliation)'
        use: (weapon, weaponDamage) ->
            damage = 2 * weaponDamage
            return [ damage, [] ]
    rapidFire:
        name: 'rapid fire',
        attackType: attackTypes.ranged
        mana: 5
        description: 'Shoot 6 arrows in rapid succession with lowered damage (25% damage).'
        use: (weapon, weaponDamage) ->
            damage = 1.5 * weaponDamage
            return [ damage, [] ]
    fireArrow:
        name: 'fire arrow'
        attackType: attackTypes.magic
        mana: 2
        description: '200% weapon damage, 10% chance to ignite enemy'
        use: (weapon, weaponDamage) ->
            if random() < 10 then effects = [ { effect: heroStates.burning, ticks: 3 } ] else effects = []
            damage = 2 * weaponDamage * weapon.spellAmplification
            return [ damage, effects ]
    iceArrow:
        name: 'ice arrow'
        attackType: attackTypes.magic
        mana: 2
        description: '200% weapon damage, 10% chance to freeze enemy'
        use: (weapon, weaponDamage) ->
            if random() < 10 then effects = [ { effect: heroStates.frozen, ticks: 1 } ] else effects = []
            damage = 2 * weaponDamage * weapon.spellAmplification
            return [ damage, effects ]
    soulArrow:
        name: 'soul arrow'
        attackType: attackTypes.magic
        mana: 2
        description: '240% weapon damage'
        use: (weapon, weaponDamage) ->
            damage = 2.4 * weaponDamage * weapon.spellAmplification
            return [ damage, [] ]
    iceShards:
        name: 'ice shards'
        attackType: attackTypes.magic
        mana: 6
        description: '50% weapon damage, 6 shards, 10% chance to cause bleeding'
        use: (weapon, weaponDamage) ->
            damage += 3 * weaponDamage * weapon.spellAmplification
            effects = []
            for i in [1..6]
                if random() < 10 then effects.push { effect: heroStates.bleeding, ticks: 3 }
            return [ damage, effects ]
    fireBall:
        name: 'fire ball'
        attackType: attackTypes.magic
        mana: 5
        description: '300% weapon damage, 25% chance to ignite enemy'
        use: (weapon, weaponDamage) ->
            damage += 3 * weaponDamage * weapon.spellAmplification
            if random() < 25 then effects = [] else effects = [ { effect: heroStates.burning, ticks: 3 } ]
            return [ damage, effects ]
    soulBolt:
        name: 'soul bolt'
        attackType: attackTypes.magic
        mana: 4
        description: '300% weapon damage'
        use: (weapon, weaponDamage) ->
            damage += 3 * weaponDamage * weapon.spellAmplification
            return [ damage, [] ]

getAll = () ->
    return abilities

getSpells = () ->
    spells = {}
    for key, value of abilities
        if value.attackType is attackTypes.magic then spells[key] = value
    return spells

module.exports =
    getAll: getAll
    getNames: getNames
    getSpells: getSpells
