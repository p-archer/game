chalk = require 'chalk'
{ attackTypes, weaponTypes, weaponStates, speed } = require '../constants'
{ random, log, err, warn, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()
Abilities = require '../abilities/abilities' # needed elsewhere
abilities = Abilities.getNames()

getDamage = (weapon) ->
    return (actor) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        return [ [{ amount: damage, type: attackTypes.physical }], [] ]

showCombat = (source, getDamageStr) ->
    name = source.weapon.name
    if source.weapon.prefix? then name = source.weapon.prefix.name + ' ' + name
    if source.weapon.suffix? then name = name + ' of ' + source.weapon.suffix.name
    log 'e\tattack with ' + chalk.blueBright(name) + ' (' + chalk.green(getDamageStr(source)) + ')'
    log '\tspell amplification: ' + getPercent(source.weapon.spellAmplification) + ' mana consumption: ' + getPercent(source.weapon.manaAdjustment, true)
    log()
    return

wands =
    shortWand:
        name: 'short wand'
        min: 1
        max: 1.4
        speed: speed.normal
        requirements:
            level: 0
            skills: []
        cost: 100
        quality: 1
        spells: [abilities.fireArrow, abilities.iceArrow]
        description: 'Standard short wand.'
    boneWand:
        name: 'bone wand'
        min: 1.2
        max: 1.6
        speed: speed.normal
        requirements:
            level: 5
            skills: [{skill: skills.magic, level: 3}]
        cost: 140
        quality: 1
        spells: [abilities.fireArrow, abilities.iceArrow, abilities.soulArrow]
        description: 'Wand made out of bone.'
    wand:
        name: 'wand'
        min: 1.6
        max: 2.0
        speed: speed.normal
        requirements:
            level: 10
            skills: [{skill: skills.improvedMagic, level: 1}]
        cost: 500
        quality: 2
        spells: [abilities.fireArrow, abilities.iceArrow]
        description: 'Standard wand.'
    iceWand:
        name: 'ice wand'
        min: 1.8
        max: 2.2
        speed: speed.normal
        requirements:
            level: 10
            skills: [{skill: skills.improvedMagic, level: 2}]
        cost: 1000
        quality: 2
        spells: [abilities.soulArrow, abilities.iceArrow, abilities.iceShards]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Magic wand resembling a frozen arm.'
    grayWand:
        name: 'gray wand'
        min: 2.4
        max: 2.6
        speed: speed.normal
        requirements:
            level: 13
            skills: [{skill: skills.improvedMagic, level: 4}]
        cost: 1900
        quality: 2
        spells: [abilities.lifeDrain, abilities.manaDrain, abilities.soulBolt]
        description: ''
    yewWand:
        name: 'yew wand'
        min: 2.2
        max: 2.4
        speed: speed.normal
        requirements:
            level: 10
            skills: [{skill: skills.improvedMagic, level: 3}]
        cost: 1500
        quality: 2
        spells: [abilities.fireBall, abilities.iceShards, abilities.soulBolt]
        description: 'Wand made from yew.'
    darkWand:
        name: 'dark wand'
        min: 3.0
        max: 3.4
        speed: speed.normal
        requirements:
            level: 25
            skills: [{skill: skills.advancedMagic, level: 3}]
        cost: 3000
        quality: 3
        spells: [abilities.iceShards, abilities.soulBolt, abilities.fireBall, abilities.lifeDrain, abilities.manaDrain]
        description: ''
    blackWand:
        name: 'black wand'
        min: 2.6
        max: 3.0
        speed: speed.normal
        requirements:
            level: 25
            skills: [{skill: skills.advancedMagic, level: 1}]
        cost: 2500
        quality: 3
        spells: [abilities.fireBall, abilities.iceShards, abilities.soulBolt]
        description: 'Wand made from unknown materials.'

for key, wand of wands
    wand.init = (wand) ->
        key = @spells[random(@spells.length)].key
        spell = Abilities.getAll()[key]
        spellAmplification = 1 + (random(500) / 10000)
        manaAdjustment = 1
        description = wand.description + ' (spell amp: ' + getPercent(spellAmplification) + ' mana cost: ' + getPercent(manaAdjustment, true) + ')'
        return Object.assign {}, wand, { spell: spell, spellAmplification: spellAmplification, manaAdjustment: manaAdjustment,  description: description, range: 1, showCombat: showCombat, type: weaponTypes.wand, getDamage: getDamage(wand) }

module.exports = wands
