{ log, err, warn, getPercent } = require '../../general'
{ states, attackTypes, heroStates, actions } = require '../../constants'

chalk = require 'chalk'
Hero = require '../../hero.coffee'
Monster = require '../../monsters/monsters.coffee'
inspector = require '../../inspector.coffee'

time = null # combat loop timer

handleMonstersTurn = (monster, hero, map, exitState) ->
    action = monster.getAction monster, hero
    [ monster, damages, effects ] = Monster.takeAction monster, hero, action
    [ hero, _, hp, mana ] = Hero.takeDamage hero, damages, effects
    monster = Monster.create Object.assign {}, monster, { hp: monster.hp + hp, mana: monster.mana + mana }
    Monster.adjust map, hero.position, monster

    return [ true, exitState, hero, map ]
applyStatuses = (actor, create, takeDamage) ->
    effects = [actor.state...].filter (x) ->
        return x.ticks isnt 0

    effects = effects.map (x) ->
        x.ticks--
        return x

    # TODO stack bleeding, increase ticks for burning
    damages = []
    for state in effects
        switch state.effect
            when heroStates.bleeding
                log chalk.blueBright '> ' + actor.name + ' is bleeding'
                damages.push { amount: actor.maxhp * 0.1, type: attackTypes.pure }
            when heroStates.burning
                log chalk.blueBright '> ' + actor.name + ' is burning'
                damages.push { amount: actor.maxhp * 0.1, type: attackTypes.fire }
            when heroStates.maimed
                log chalk.blueBright '> ' + actor.name + ' is maimed'
            when heroStates.poisoned
                log chalk.blueBright '> ' + actor.name + ' is poisoned'
                damages.push { amount: Math.max(actor.hp * 0.1, 0.5), type: attackTypes.poison }

    actor = create Object.assign {}, actor, { state: [effects...] }
    return takeDamage actor, damages, []

retreat = (state, map, hero, monster) ->
    if hero.combatPos is 1
        log '> can not retreat any further'
    else
        [ hero, _ ] = applyStatuses hero, Hero.create, Hero.takeDamage
        hero = Hero.create Object.assign {}, hero, { combatPos: Math.max(1, hero.combatPos - hero.movement), free: hero.free + 10 }
    return [ true, state, hero, map ]
approach = (state, map, hero, monster) ->
    distance = monster.combatPos - hero.combatPos
    if distance is 1
        log '> already in melee range'
    else
        [ hero, _ ] = applyStatuses hero, Hero.create, Hero.takeDamage
        hero = Hero.create Object.assign {}, hero, { combatPos: Math.min(monster.combatPos - 1, hero.combatPos + hero.movement), free: hero.free + 10 }
    return [ true, state, hero, map ]
attack = (state, map, hero, monster) ->
    distance = monster.combatPos - hero.combatPos
    if distance > 1 and hero.weapon.range is 1
        log '> not in attack range'
        return [ true, state, hero, map ]
    else
        [ hero, _ ] = applyStatuses hero, Hero.create, Hero.takeDamage
        [ damages, effects ] = Hero.attack hero, monster
        hero = Hero.learn hero, damages
        [ monster, isAlive, hp, mana ] = Monster.takeDamage monster, damages, effects
        Monster.adjust map, hero.position, monster
        hero = Hero.create Object.assign {}, hero, { hp: hero.hp + hp, mana: hero.mana + mana, free: hero.free + hero.weapon.speed }
        if not isAlive
            [ gold, xp ] = Monster.dead monster, hero
            hero = Hero.giveGold hero, gold
            hero = Hero.gainXP hero, xp
            map = Monster.remove map, hero.position
            return [ true, { state: states.wait, param: states.normal } , hero, map ]

    return [ true, state, hero, map ]
useSpell = (state, map, hero, spell) ->
    # TODO mana adjustment based on weapon and skills
    requiredMana = spell.mana
    if hero.weapon.manaAdjustment?
        requiredMana *= hero.weapon.manaAdjustment
    if requiredMana > hero.mana
        err '> not enough mana'
        return [ true, state, hero, map ]

    [ hero, _ ] = applyStatuses hero, Hero.create, Hero.takeDamage
    hero = Hero.create Object.assign {}, hero, { mana: hero.mana - requiredMana, free: hero.free + spell.speed }
    monster = map.current.isMonster hero.position

    spellAmp = if hero.weapon.spellAmplification? then hero.weapon.spellAmplification else 1
    takeDamage = (damages, effects) ->
        damage.amount * spellAmp for damage in damages
        return Monster.takeDamage monster, damages, effects
    [ monster, isAlive, hp, mana ] = Hero.useSpell spell, hero, monster, takeDamage
    Monster.adjust map, hero.position, monster
    hero = Hero.create Object.assign {}, hero, { hp: hero.hp + hp, mana: hero.mana + mana }
    if not isAlive
        [ gold, xp ] = Monster.dead monster, hero
        hero = Hero.giveGold hero, gold
        hero = Hero.gainXP hero, xp
        map = Monster.remove map, hero.position
        return [ true, { state: states.wait, param: states.normal }, hero, map ]

    if monster? and monster.hp > 0
        [ _, hero, map ] = handleLoop state, hero, map

    return [ true, { state: states.combat.main }, hero, map ]
switchArrowType = (state, map, hero) ->
    index = hero.arrow
    if ++index >= hero.quiver.length then index = 0
    hero = Hero.create Object.assign {}, hero, { arrow: index }
    return [ true, { state: state.state }, hero, map ]
switchBroadhead = (state, map, hero) ->
    index = hero.broadhead
    if ++index >= hero.broadheads.length then index = 0
    hero = Hero.create Object.assign {}, hero, { broadhead: index }
    return [ true, { state: state.state }, hero, map ]

initTimer = () ->
    time = 0 # TODO this is not functional

isReady = (actor, time) ->
    return actor.free <= time

handleLoop = (state, hero, map) ->
    while not isReady hero, time
        [ hero, _ ] = applyStatuses hero, Hero.create, Hero.takeDamage
        monster = map.current.isMonster hero.position
        if monster? and monster.hp > 0
            [ monster, isAlive ] = applyStatuses monster, Monster.create, Monster.takeDamage
            if not isAlive
                [ gold, xp ] = Monster.dead monster, hero
                hero = Hero.giveGold hero, gold
                hero = Hero.gainXP hero, xp
                map = Monster.remove map, hero.position
                return [ { state: states.wait, param: states.normal } , hero, map ]

            if isReady monster, time
                [ _, state, hero, map ] = handleMonstersTurn monster, hero, map, { state: state.state }
        time++
        # warn 'timeslot', time
    return [ { state: state.state }, hero, map ]

outputter = (state, hero, map, exitState) ->
    monster = map.current.isMonster hero.position
    str = ''
    heroPos = hero.combatPos || 10
    monsterPos = monster.combatPos || 40
    inspector.init hero, monster

    for i in [0...52]
        switch i
            when heroPos then str += chalk.green 'x'
            when monsterPos then str += chalk.redBright 'x'
            else str += '_'
    distance = Math.abs heroPos - monsterPos
    str += '  distance: ' + distance

    # console.clear()
    log()
    log str
    log()
    log 'a/d\tfall back/approach'
    hero.weapon.showCombat hero, Hero.getDamageStr, distance
    if (hero.abilities? and hero.abilities.length > 0) or hero.weapon.spell?
        log 'f\tuse ability'

    if state.param is 'start'
        initTimer()
    return

mutator = (state, input, hero, map) ->
    monster = map.current.isMonster hero.position
    if not monster.combatPos? then monster = Monster.adjust map, hero.position, { combatPos: 40 }
    if not hero.combatPos? then hero = Hero.create Object.assign {}, hero, { combatPos: 10 }

    # TODO hero frozen or stunned
    switch input
        when 'a' then [ handled, state, hero, map] = retreat state, map, hero, monster
        when 'd' then [ handled, state, hero, map] = approach state, map, hero, monster
        when 'e' then [ handled, state, hero, map] = attack state, map, hero, monster
        when 'f' then return [ true, { state: states.combat.abilities }, hero, map ]
        when '1' then if hero.quiver? then [ handled, state, hero, map] = switchArrowType state, map, hero
        when '2' then if hero.broadheads? then [ handled, state, hero, map] = switchBroadhead state, map, hero

    monster = map.current.isMonster hero.position
    if handled and monster? and monster.hp > 0 and not isReady hero, time
        return [ true, handleLoop(state, hero, map)... ]

    return [ handled, state, hero, map ]

abilitiesOutputter = (state, hero, map) ->
    index = 0
    for ability in hero.abilities
        requiredMana = ability.mana * (if hero.weapon.manaAdjustment? then hero.weapon.manaAdjustment else 1)
        log ''+index++ + '\t' + chalk.yellow(ability.name.toFixed(24)) + chalk.blueBright(requiredMana.toFixed(2) + ' mana') + '\t' + ability.description
    if hero.weapon.spell
        requiredMana = hero.weapon.spell.mana * (if hero.weapon.manaAdjustment? then hero.weapon.manaAdjustment else 1)
        log 'f\t' + chalk.yellow(hero.weapon.spell.name.toFixed(24)) + chalk.blueBright(requiredMana.toFixed(2) + ' mana') + '\t' + hero.weapon.spell.description
    return

abilitiesMutator = (state, input, hero, map) ->
    spell = null
    if input is 'f' and hero.weapon.spell?
        spell = hero.weapon.spell

    num = parseInt input, 10
    abilities = hero.abilities
    if (not isNaN num) and num < abilities.length
        spell = hero.abilities[num]

    if spell isnt null
        return useSpell state, map, hero, spell

    return [ false, state, hero, map ]

register = (processors, outputProcessors) ->
    return [
        [
            processors...
            { state: states.combat.main, fn: mutator }
            { state: states.combat.abilities, fn: abilitiesMutator }
        ]
        [
            outputProcessors...
            { state: states.combat.main, fn: outputter }
            { state: states.combat.abilities, fn: abilitiesOutputter }
        ]
    ]

module.exports =
    register: register
