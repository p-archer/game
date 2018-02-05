chalk = require 'chalk'
{ attackTypes, weaponStates, heroStates } = require '../constants'
{ random, log } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        if distance is 1
            combatCasting = actor.skills.combatCasting
            cof = (if combatCasting? then 0.5 - (combatCasting.level * combatCasting.bonus) else 0.5) * 100
            log chalk.yellow ' -- casting at melee range, chance of failure ' + chalk.redBright(cof + '%')
            if random() < cof then return damage else return 0
        else
            return damage

tomes =
    tomeFragment:
        name: 'tome fragment'
        min: 1.0
        max: 1.4
        attackType: attackTypes.magic
        requirements:
            level: 0
            skills: []
        cost: 120
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Damaged tome of a forgotten sorcerer.'

    tome:
        name: 'tome'
        min: 1.8
        max: 2.4
        attackType: attackTypes.magic
        requirements:
            level: 10
            magic: 10
            skills: [{skill: skills.improvedMagic, level: 1}]
        cost: 600
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Ancient tome containing spells and curses.'

    grimoire:
        name: 'grimoire'
        min: 3.0
        max: 3.4
        attackType: attackTypes.magic
        requirements:
            level: 20
            magic: 20
            skills: [{skill: skills.advancedMagic, level: 1}]
        cost: 2000
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'A book written by a mad summoner.'

module.exports = tomes
