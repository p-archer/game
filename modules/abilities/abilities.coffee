{ log, err, random } = require '../general'
{ attackTypes, heroStates, weaponStates } = require '../constants'

getNames = () ->
    names = {}
    for own key, value of abilities
        names[key] = { key: key, name: value.name }
    return names

abilities =
    powerShot:
        name: 'power shot'
        attackType: attackTypes.ranged
        mana: 2
        description: '+100% damage to a normal attack. (No retaliation)'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            return takeDamage damage * 2, effects
    rapidFire:
        name: 'rapid fire',
        attackType: attackTypes.ranged
        mana: 3
        description: 'Shoot 6 arrows in rapid succession with lowered damage (50% damage).'
        use: (getDamage, takeDamage) ->
            target = null
            isAlive = null
            for i in [1..6]
                [ damage, effects ] = getDamage()
                [ target, isAlive ] = takeDamage damage * 0.5, effects, target
            return [ target, isAlive ]

    arcaneBolt:
        name: 'arcane bolt'
        attackType: attackTypes.magic
        mana: 0.5
        description: '100% weapon damage'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            return takeDamage damage, effects
    arcaneTorrent:
        name: 'arcane torrent'
        attackType: attackTypes.magic
        mana: 1.2
        description: '20% weapon damage, 5-10 projectiles'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            target = null
            isAlive = null
            sumhp = 0
            summana = 0
            attacks = 5 + random(5)
            for i in [0...attacks]
                [ damage, effects ] = getDamage()
                [ target, isAlive, hp, mana ] = takeDamage 0.2 * damage, effects, target
                sumhp += hp
                summana += mana
            return [ target, isAlive, sumhp, summana ]
    fireArrow:
        name: 'fire arrow'
        attackType: attackTypes.magic
        mana: 2
        description: '200% weapon damage, 10% chance to ignite enemy'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            if random() < 10 then effects = [ effects..., { effect: heroStates.burning, ticks: 3 } ]
            return takeDamage 2 * damage, effects
    iceArrow:
        name: 'ice arrow'
        attackType: attackTypes.magic
        mana: 2
        description: '200% weapon damage, 10% chance to freeze enemy'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            if random() < 10 then effects = [ effects..., { effect: heroStates.frozen, ticks: 1 } ]
            return takeDamage 2 * damage, effects
    soulArrow:
        name: 'soul arrow'
        attackType: attackTypes.magic
        mana: 2
        description: '240% weapon damage'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            return takeDamage 2.4 * damage, effects
    iceShards:
        name: 'ice shards'
        attackType: attackTypes.magic
        mana: 6
        description: '50% weapon damage, 6 shards, 10% chance to cause bleeding'
        use: (getDamage, takeDamage) ->
            target = null
            isAlive = null
            sumhp = 0
            summana = 0
            for i in [1..6]
                [ damage, effects ] = getDamage()
                if random() < 10 then effects = [ effects..., { effect: heroStates.bleeding, ticks: 3 } ]
                [ target, isAlive, hp, mana ] = takeDamage 0.5 * damage, effects, target
                sumhp += hp
                summana += mana
            return [ target, isAlive, sumhp, summana ]
    fireBall:
        name: 'fire ball'
        attackType: attackTypes.magic
        mana: 5
        description: '300% weapon damage, 25% chance to ignite enemy'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            if random() < 25 then effects = [ effects..., { effect: heroStates.burning, ticks: 3 } ]
            return takeDamage 3 * damage, effects
    soulBolt:
        name: 'soul bolt'
        attackType: attackTypes.magic
        mana: 4
        description: '300% weapon damage'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            return takeDamage 3 * damage, []
    lifeDrain:
        name: 'life drain'
        attackType: attackTypes.magic
        mana: 5
        description: 'drain hp from enemy (100% weapon damage)'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            return takeDamage damage, [ effects..., { effect: weaponStates.lifeDrain, ticks: 1 } ]
    manaDrain:
        name: 'mana drain'
        attackType: attackTypes.magic
        mana: 5
        description: 'drain hp from enemy (100% weapon damage)'
        use: (getDamage, takeDamage) ->
            [ damage, effects ] = getDamage()
            return takeDamage damage, [ effects..., { effect: weaponStates.manaDrain, ticks: 1 } ]

# statuses: immolate, bleed
# damage: stone fist, locust swarm (can poison)
# curses: slow, weaken, shatter armour

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
