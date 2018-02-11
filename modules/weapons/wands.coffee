chalk = require 'chalk'
{ attackTypes, weaponStates } = require '../constants'
{ random, log, err, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()
Abilities = require '../abilities/abilities' # needed elsewhere
abilities = Abilities.getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        if distance is 1
            return damage
        else
            return 0

wands =
    shortWand:
        name: 'short wand'
        min: 1
        max: 1.4
        attackType: attackTypes.magic
        requirements:
            level: 0
            skills: []
        cost: 100
        quality: 1
        spells: [abilities.fireArrow, abilities.iceArrow]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard short wand.'
    boneWand:
        name: 'bone wand'
        min: 1.2
        max: 1.6
        attackType: attackTypes.magic
        requirements:
            level: 5
            mastery: 5
            skills: [{skill: skills.magic, level: 3}]
        cost: 140
        quality: 1
        spells: [abilities.fireArrow, abilities.iceArrow, abilities.soulArrow]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Wand made out of bone.'
    wand:
        name: 'wand'
        min: 1.6
        max: 2.0
        attackType: attackTypes.magic
        requirements:
            level: 10
            mastery: 10
            skills: [{skill: skills.improvedMagic, level: 1}]
        cost: 500
        quality: 2
        spells: [abilities.fireArrow, abilities.iceArrow]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard wand.'
    iceWand:
        name: 'ice wand'
        min: 1.8
        max: 2.2
        attackType: attackTypes.magic
        requirements:
            level: 10
            mastery: 10
            skills: [{skill: skills.improvedMagic, level: 2}]
        cost: 1000
        quality: 2
        spells: [abilities.soulArrow, abilities.iceArrow, abilities.iceShards]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Magic wand resembling a frozen arm.'
    yewWand:
        name: 'yew wand'
        min: 2.2
        max: 2.4
        attackType: attackTypes.magic
        requirements:
            level: 10
            mastery: 10
            skills: [{skill: skills.improvedMagic, level: 3}]
        cost: 1500
        quality: 2
        spells: [abilities.fireBall, abilities.fireArrow, abilities.iceArrow, abilities.iceShards, abilities.soulArrow, abilities.soulBolt]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Wand made from yew.'
    blackWand:
        name: 'black wand'
        min: 2.6
        max: 3.0
        attackType: attackTypes.magic
        requirements:
            level: 25
            mastery: 25
            skills: [{skill: skills.advancedMagic, level: 1}]
        cost: 2500
        quality: 3
        spells: [abilities.soulArrow, abilities.soulBolt]
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Wand made from unknown materials.'

for key, wand of wands
    wand.init = (wand) ->
        key = @spells[random(@spells.length)].key
        spell = Abilities.getAll()[key]
        spellAmplification = 1 + (random(5) / 100)
        manaAdjustment = 1
        description = wand.description + ' (spell amp: ' + getPercent(spellAmplification) + ' mana cost: ' + getPercent(manaAdjustment, true) + ')'
        return Object.assign {}, wand, { spell: spell, spellAmplification: spellAmplification, manaAdjustment: manaAdjustment,  description: description, range: 1 }

module.exports = wands
