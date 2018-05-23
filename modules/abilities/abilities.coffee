{ log, err, random } = require '../general'
{ attackTypes, heroStates, weaponStates, speed } = require '../constants'

getNames = () ->
    names = {}
    for own key, value of abilities
        names[key] = { key: key, name: value.name }
    return names

abilities =
    strafe: # TODO solve movement issue
        name: 'strafe'
        mana: 4
        description: 'Retreat while firing 3 shots with decreased damage (50%).'
        damage: 0.5
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            sumDmg = []
            sumEffects = []
            for i in [1..3]
                [ damages, effects ] = getDamage()
                for damage in damages
                    damage.amount *= @damage
                sumDmg = [ sumDmg..., damages... ]
                sumEffects = [ sumEffects..., effects... ]
            return takeDamage sumDmg, effects
    powerShot:
        name: 'power shot'
        mana: 3
        description: '+100% damage to a normal attack. +10% chance for critical hit.'
        damage: 2
        speed: speed.slow
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            if random() < 10 then effects = [ effects..., { effect: weaponStates.critical, ticks: 1 } ]
            for damage in damages
                damage.amount *= @damage

            return takeDamage damages, effects
    rapidFire:
        name: 'rapid fire',
        mana: 3
        description: 'Shoot 6 arrows in rapid succession with lowered damage (50% damage).'
        damage: 0.5
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            sumDmg = []
            sumEffects = []
            for i in [1..6]
                [ damages, effects ] = getDamage()
                for damage in damages
                    damage.amount *= @damage
                sumDmg = [ sumDmg..., damages... ]
                sumEffects = [ sumEffects..., effects... ]
            return takeDamage sumDmg, effects

    arcaneBolt:
        name: 'arcane bolt'
        spell: true
        mana: 0.5
        description: '80% weapon damage'
        damage: 0.8
        speed: speed.fast
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.arcane
            return takeDamage damages, effects
    arcaneTorrent:
        name: 'arcane torrent'
        spell: true
        mana: 1.2
        description: '20% weapon damage, 4-8 projectiles'
        damage: 0.2
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            sumDmg = []
            sumEffects = []
            attacks = 4 + random(4)
            for i in [0..attacks]
                [ damages, effects ] = getDamage()
                for damage in damages
                    damage.amount *= @damage
                    damage.type = attackTypes.arcane
                sumDmg = [ sumDmg..., damages... ]
                sumEffects = [ sumEffects..., effects... ]
            return takeDamage sumDmg, sumEffects
    fireArrow:
        name: 'fire arrow'
        spell: true
        mana: 2
        description: '200% weapon damage, 10% chance to ignite enemy'
        chance: 10
        damage: 2
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.fire
            effects = [ effects..., { effect: heroStates.burning, ticks: 3} ] if random(10000) < @chance * 100
            return takeDamage damages, effects
    iceArrow:
        name: 'ice arrow'
        spell: true
        mana: 2
        description: '200% weapon damage, 10% chance to freeze enemy'
        chance: 10
        damage: 2
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.ice
            effects = [ effects..., { effect: heroStates.frozen, ticks: 1} ] if random(10000) < @chance * 100
            return takeDamage damages, effects
    soulArrow:
        name: 'soul arrow'
        spell: true
        mana: 2
        description: '240% weapon damage'
        damage: 2.4
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.dark
            return takeDamage damages, effects
    iceShards:
        name: 'ice shards'
        spell: true
        mana: 6
        description: '50% weapon damage, 6 shards, 10% chance to cause bleeding'
        damage: 0.5
        chance: 10
        speed: speed.slow
        use: (getDamage, takeDamage) ->
            sumDmg = []
            sumEffects = []
            for i in [1...6]
                [ damages, effects ] = getDamage()
                effects = [ effects..., { effect: heroStates.bleeding, ticks: 3 } ] if random(10000) < @chance * 100
                for damage in damages
                    damage.amount *= @damage
                    damage.type = attackTypes.ice
                sumDmg = [ sumDmg..., damages... ]
                sumEffects = [ sumEffects..., effects... ]
            return takeDamage sumDmg, sumEffects
    fireBall:
        name: 'fire ball'
        spell: true
        mana: 5
        description: '300% weapon damage, 25% chance to ignite enemy'
        damage: 3
        chance: 25
        speed: speed.slow
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.fire
            effects = [ effects..., { effect: heroStates.burning, ticks: 1} ] if random(10000) < @chance * 100
            return takeDamage damages, effects
    soulBolt:
        name: 'soul bolt'
        spell: true
        mana: 4
        description: '300% weapon damage'
        damage: 3
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.dark
            return takeDamage damages, effects
    lifeDrain:
        name: 'life drain'
        spell: true
        mana: 5
        description: 'drain hp from enemy (100% weapon damage)'
        damage: 1
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.dark
            effects = [ effects..., { effect: weaponStates.lifeDrain, ticks: 1} ]
            return takeDamage damages, effects
    manaDrain:
        name: 'mana drain'
        spell: true
        mana: 5
        description: 'drain hp from enemy (100% weapon damage)'
        damage: 1
        speed: speed.normal
        use: (getDamage, takeDamage) ->
            [ damages, effects ] = getDamage()
            for damage in damages
                damage.amount *= @damage
                damage.type = attackTypes.dark
            effects = [ effects..., { effect: weaponStates.manaDrain, ticks: 1} ]
            return takeDamage damages, effects

# statuses: immolate, bleed
# damage: stone fist, locust swarm (can poison), lightning spells /arrow, bolt/, locust swarm
# curses: slow, weaken, shatter armour

getAll = () ->
    return abilities

getSpells = () ->
    spells = {}
    for key, value of abilities
        if value.spell then spells[key] = value
    return spells

module.exports =
    getAll: getAll
    getNames: getNames
    getSpells: getSpells
