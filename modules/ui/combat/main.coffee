{ log, err } = require '../../general'
{ states, attackTypes } = require '../../constants'

chalk = require 'chalk'
Entity = require '../../entity.coffee'
Hero = require '../../hero.coffee'
Monster = require '../../monsters/monsters.coffee'
inspector = require '../../inspector.coffee'

handleMonstersTurn = (monster, hero, map, exitState) ->
    [ monster, isAlive ] = Entity.applyStatuses monster, Monster.create, Monster.takeDamage
    if not isAlive
        [ gold, xp ] = Monster.dead monster, hero
        hero = Hero.giveGold hero, gold
        hero = Hero.gainXP hero, xp
        map = Monster.remove map, hero.position
        return [ true, { state: states.wait, param: states.normal } , hero, map ]

    [ monster, damage, effects ] = Monster.takeAction monster, hero
    [ hero, _ ] = Hero.takeDamage hero, monster.weapon.attackType, damage, effects
    Monster.adjust map, hero.position, monster
    return [ true, exitState, hero, map ]

retreat = (state, map, hero, monster) ->
    if hero.combatPos is 1
        log '> can not retreat any further'
        return [ true, state, hero, map ]
    else
        [ hero, _ ] = Entity.applyStatuses hero, Hero.create, Hero.takeDamage
        hero = Hero.create Object.assign {}, hero, { combatPos: Math.max(1, hero.combatPos - hero.movement) }

        return handleMonstersTurn monster, hero, map, { state: state.state }
approach = (state, map, hero, monster) ->
    distance = monster.combatPos - hero.combatPos
    if distance is 1
        log '> already in melee range'
        return [ true, state, hero, map ]
    else
        [ hero, _ ] = Entity.applyStatuses hero, Hero.create, Hero.takeDamage
        hero = Hero.create Object.assign {}, hero, { combatPos: Math.min(monster.combatPos - 1, hero.combatPos + hero.movement) }

        return handleMonstersTurn monster, hero, map, { state: state.state }
attack = (state, map, hero, monster) ->
    distance = monster.combatPos - hero.combatPos
    if distance > 1 and hero.weapon.attackType isnt attackTypes.ranged
        log '> not in attack range'
        return [ true, state, hero, map ]
    else
        [ hero, _ ] = Entity.applyStatuses hero, Hero.create, Hero.takeDamage
        [ damage, effects ] = Hero.attack hero, monster
        [ monster, isAlive ] = Monster.takeDamage monster, hero.weapon.attackType, damage, effects
        if not isAlive
            [ gold, xp ] = Monster.dead monster, hero
            hero = Hero.giveGold hero, gold
            hero = Hero.gainXP hero, xp
            map = Monster.remove map, hero.position
            return [ true, { state: states.wait, param: states.normal } , hero, map ]

        # retaliate
        if distance is 1
            log '> ' + monster.name + ' is retaliating'
            [ monster, damage, effects ] = Monster.attack monster, hero
            [ hero, _ ] = Hero.takeDamage hero, monster.weapon.attackType, damage, effects

        # TODO hero retaliate
        # monster's turn
        return handleMonstersTurn monster, hero, map, { state: state.state }
useSpell = (state, map, hero, spell) ->
    [ success, rest... ] = Hero.useSpell spell, hero, map
    if success
        [ hero, damage, effects ] = rest
        [ hero, _ ] = Entity.applyStatuses hero, Hero.create, Hero.takeDamage
        monster = map.current.isMonster hero.position
        [ monster, isAlive ] = Monster.takeDamage monster, attackTypes.magic, damage, effects
        if not isAlive
            [ gold, xp ] = Monster.dead monster, hero
            hero = Hero.giveGold hero, gold
            hero = Hero.gainXP hero, xp
            map = Monster.remove map, hero.position
            return [ true, { state: states.wait, param: states.normal }, hero, map ]

        # monster's turn
        return handleMonstersTurn monster, hero, map, null
    else
        return [ true, state, hero, map ]
switchArrowType = (state, map, hero) ->
    index = hero.quiver.indexOf hero.arrow
    if ++index >= hero.quiver.length then index = 0
    hero = Hero.create Object.assign {}, hero, { arrow: hero.quiver[index] }
    return [ true, { state: state.state }, hero, map ]
switchBroadhead = (state, map, hero) ->
    index = hero.broadheads.indexOf hero.broadhead
    if ++index >= hero.broadheads.length then index = 0
    hero = Hero.create Object.assign {}, hero, { broadhead: hero.broadheads[index] }
    return [ true, { state: state.state }, hero, map ]

outputter = (state, hero, map, exitState) ->
    monster = map.current.isMonster hero.position
    str = ''
    heroPos = hero.combatPos || 10
    monsterPos = monster.combatPos || 40 # +tactics
    inspector.init hero, monster

    for i in [0...51]
        switch i
            when heroPos then str += chalk.green 'x'
            when monsterPos then str += chalk.redBright 'x'
            else str += '_'
    str += '  distance: ' + (monsterPos - heroPos)

    # console.clear()
    log()
    log str
    log()
    log 'a\tfall back'
    log 'd\tapproach enemy'
    switch hero.weapon.attackType
        when attackTypes.melee
            log 'e\tattack with ' + chalk.blueBright(hero.weapon.name)
            log ''
        when attackTypes.ranged
            log 'e\tattack with ' + chalk.blueBright(hero.weapon.name)
            log '\tusing ' + chalk.yellow(hero.arrow.name) + ' with ' + chalk.yellow(hero.broadhead.name)
            log '\trange: ' +  (hero.arrow.range - 1)*100 + '% damage: ' + (hero.arrow.damage - 1)*100 + '%'
            log '\teffects: ' + hero.broadhead.description
            log ''
            log '1\tswitch arrow type'
            log '2\tswitch broadheads'
        when attackTypes.magic
            log 'e\tattack with ' + chalk.blueBright(hero.weapon.name)
            log '\tspellAmplification: ' + (hero.weapon.spellAmplification-1)*100 + '% mana consumption: ' + (hero.weapon.manaAdjustment-1)*100 + '%'
            log ''
    log 'f\tuse ability'
    log()
    log 'q\tdisengage'

    return

mutator = (state, input, hero, map) ->
    monster = map.current.isMonster hero.position
    if not monster.combatPos? then monster = Monster.adjust map, hero.position, { combatPos: 40 }
    if not hero.combatPos? then hero = Hero.create Object.assign {}, hero, { combatPos: 10 }

    switch input
        when 'a' then return retreat state, map, hero, monster
        when 'd' then return approach state, map, hero, monster
        when 'e' then return attack state, map, hero, monster
        when 'f' then return [ true, { state: states.combat.abilities }, hero, map ]
        when '1' then if hero.weapon.attackType is attackTypes.ranged then return switchArrowType state, map, hero
        when '2' then if hero.weapon.attackType is attackTypes.ranged then return switchBroadhead state, map, hero

    return [ false, state, hero, map ]

abilitiesOutputter = (state, hero, map) ->
    index = 0
    for own key, ability of hero.abilities
        log ''+index++ + '\t' + ability.name.toFixed(24) + ability.description
    if hero.weapon.spell
        log 'f\t' + hero.weapon.spell.name.toFixed(24) + hero.weapon.spell.description
    return

abilitiesMutator = (state, input, hero, map) ->
    spell = null
    if input is 'f' and hero.weapon.spell?
        spell = hero.weapon.spell

    num = parseInt input, 10
    abilities = hero.abilities.keys
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
