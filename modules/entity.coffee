chalk = require 'chalk'

{ log, random, err } = require './general'
{ attackTypes, weaponStates, heroStates, WEAPON_GAIN_FACTOR } = require './constants'
Weapon = require './weapons/weapons.coffee'
Armour = require './armours/armours.coffee'

getDamageBonusFromSkills = (skills, attackType) ->
    skillMultiplier = 1
    for own key, skill of skills
        if skill? and skill.attackType is attackType and skill.damageBonus?
            skillMultiplier += skill.damageBonus * skill.level

    return skillMultiplier

applyStatuses = (actor, create, takeDamage) ->
    states = [actor.state...].filter (x) ->
        return x.ticks isnt 0

    states = states.map (x) ->
        x.ticks--
        return x

    damage = 0
    for state in states
        # maybe burning can be turned into magical damage?
        switch state.effect
            when heroStates.bleeding
                log '> ' + actor.name + ' is bleeding'
                damage = actor.maxhp * 0.1
            when heroStates.burning
                log '> ' + actor.name + ' is burning'
                damage = actor.maxhp * 0.1
            when heroStates.poisoned
                log '> ' + actor.name + ' is poisoned'
                damage = actor.hp * 0.1

    actor = create Object.assign {}, actor, { state: [states...] }
    return takeDamage actor, attackTypes.pure, damage, []

useModifiers = (source, target, damage) ->
    weaponState = source.weapon.state
    state = []

    if weaponState.has weaponStates.maiming
        log chalk.greenBright '> ' + target.name + ' maimed'
        state.push heroStates.maimed
    if weaponState.has weaponStates.freezing
        log chalk.greenBright '> ' + target.name + 'is frozen'
        state.push heroStates.frozen
    if weaponState.has weaponStates.burning
        log chalk.greenBright '> ' + target.name + ' is burning'
        state.push heroStates.burning
    if weaponState.has weaponStates.poisoning
        log chalk.greenBright '> ' + target.name + ' is poisoned'
        state.push heroStates.poisoned
    if weaponState.has weaponStates.bleeding
        log chalk.greenBright '> ' + target.name + ' is bleeding'
        state.push heroStates.bleeding

    if weaponState.has weaponStates.piercig
        log chalk.greenBright '> piercing hit'
    else
        damage = Armour.soakDamage source.armour, damage, source.weapon.attackType

    if weaponState.has weaponStates.critical
        log chalk.greenBright '> critical hit'
        damage *= 2

    return [ damage, state ]

module.exports =
    applyStatuses: applyStatuses
    getDamageBonusFromSkills: getDamageBonusFromSkills
