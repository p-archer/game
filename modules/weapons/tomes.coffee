chalk = require 'chalk'
{ attackTypes, weaponStates, heroStates } = require '../constants'
{ random, log, err, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()
Abilities = require '../abilities/abilities' # needed elsewhere
abilities = Abilities.getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        # TODO combat casting
        if distance is 1
            return damage
        else
            return 0

tomes =
    tomeFragment:
        name: 'tome fragment'
        min: 0.5
        max: 0.6
        attackType: attackTypes.magic
        requirements:
            level: 0
            skills: []
        cost: 120
        quality: 1
        spellAmplification: 3 # 1.5-1.8
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Damaged tome of a forgotten sorcerer.'
        spells: [abilities.fireArrow, abilities.iceArrow, abilities.soulArrow]

    tome:
        name: 'tome'
        min: 0.5
        max: 0.6
        attackType: attackTypes.magic
        requirements:
            level: 10
            mastery: 10
            skills: [{skill: skills.improvedMagic, level: 1}]
        cost: 600
        quality: 2
        spellAmplification: 4 # 2-2.4
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Ancient tome containing spells and curses.'
        spells: [abilities.fireBall, abilities.fireArrow, abilities.iceArrow, abilities.iceShards, abilities.soulArrow, abilities.soulBolt]

    grimoire:
        name: 'grimoire'
        min: 0.5
        max: 0.6
        attackType: attackTypes.magic
        requirements:
            level: 20
            mastery: 20
            skills: [{skill: skills.advancedMagic, level: 1}]
        cost: 2000
        quality: 3
        spellAmplification: 6 # 3-3.6
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'A book written by a mad summoner.'
        spells: [abilities.fireBall, abilities.fireArrow, abilities.iceArrow, abilities.iceShards, abilities.soulArrow, abilities.soulBolt]

for key, tome of tomes
    tome.init = (tome) ->
        key = @spells[random(@spells.length)].key
        spell = Abilities.getAll()[key]
        spellAmplification = tome.spellAmplification + (random(25) / 100)
        manaAdjustment = 1 + ((random(20) - 10)/100)
        description = tome.description + ' (spell amp: ' + getPercent(spellAmplification) + ' mana cost: ' + getPercent(manaAdjustment, true) + ')'
        return Object.assign {}, tome, { spell: spell, spellAmplification: spellAmplification, manaAdjustment: manaAdjustment, description: description, range: 1 }

module.exports = tomes
