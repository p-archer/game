chalk = require 'chalk'
{ attackTypes, weaponTypes, weaponStates, speed } = require '../constants'
{ random, log, err, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()
Abilities = require '../abilities/abilities' # needed elsewhere
abilities = Abilities.getNames()

getDamage = (weapon) ->
    return (actor) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        return [ [{amount: damage, type: attackTypes.physical }], [] ]

showCombat = (source, getDamageStr) ->
    name = source.weapon.name
    if source.weapon.prefix? then name = source.weapon.prefix.name + ' ' + name
    if source.weapon.suffix? then name = name + ' of ' + source.weapon.suffix.name
    log 'e\tattack with ' + chalk.blueBright(name) + ' (' + chalk.green(getDamageStr(source)) + ')'
    log '\tspell amplification: ' + getPercent(source.weapon.spellAmplification) + ' mana consumption: ' + getPercent(source.weapon.manaAdjustment, true)
    log()
    return

tomes =
    tomeFragment:
        name: 'tome fragment'
        min: 0.4
        max: 0.5
        speed: speed.normal
        requirements:
            level: 0
            skills: []
        cost: 120
        quality: 1
        spellAmplification: 3
        description: 'Damaged tome of a forgotten sorcerer.'
        spells: [abilities.fireArrow, abilities.iceArrow, abilities.soulArrow]

    tome:
        name: 'tome'
        min: 0.4
        max: 0.5
        speed: speed.normal
        requirements:
            level: 10
            skills: [{skill: skills.improvedMagic, level: 1}]
        cost: 600
        quality: 2
        spellAmplification: 4
        description: 'Ancient tome containing spells and curses.'
        spells: [abilities.fireBall, abilities.iceShards, abilities.soulBolt]

    grimoire:
        name: 'grimoire'
        min: 0.4
        max: 0.5
        speed: speed.normal
        requirements:
            level: 20
            skills: [{skill: skills.advancedMagic, level: 1}]
        cost: 2000
        quality: 3
        spellAmplification: 6
        description: 'A book written by a mad summoner.'
        spells: [abilities.fireBall, abilities.iceShards, abilities.soulBolt, abilities.lifeDrain, abilities.manaDrain]

for key, tome of tomes
    tome.init = (tome) ->
        key = @spells[random(@spells.length)].key
        spell = Abilities.getAll()[key]
        spellAmplification = tome.spellAmplification + (random(25) / 100)
        manaAdjustment = 1 + ((random(20) - 10)/100)
        description = tome.description + ' (spell amp: ' + getPercent(spellAmplification) + ' mana cost: ' + getPercent(manaAdjustment, true) + ')'
        return Object.assign {}, tome, { spell: spell, spellAmplification: spellAmplification, manaAdjustment: manaAdjustment, description: description, range: 1, showCombat: showCombat, type: weaponTypes.tome, getDamage: getDamage(tome) }

module.exports = tomes
