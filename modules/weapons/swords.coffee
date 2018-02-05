chalk = require 'chalk'
{ attackTypes, weaponStates, heroStates } = require '../constants'
{ random, log } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return () ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))

swords =
    shortSword:
        name: 'short sword'
        min: 2
        max: 3
        range: 1
        attackType: attackTypes.melee
        requirements:
            level: 0
            skills: []
        cost: 100
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard short sword.'

    scimitar:
        name: 'scimitar'
        min: 2
        max: 3.5
        range: 1
        attackType: attackTypes.melee
        requirements:
            level: 0
            skills: []
        cost: 120
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Scimitar made from high quality steel.'

    broadSword:
        name: 'broad sword'
        min: 4.5
        max: 5.5
        range: 1
        attackType: attackTypes.melee
        requirements:
            level: 12
            melee: 10
            skills: [{name: skills.improvedMelee, level: 3}]
        cost: 800
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Sword with a broad blade.'

    longSword:
        name: 'long sword'
        min: 3.5
        max: 5
        range: 1
        attackType: attackTypes.melee
        requirements:
            level: 10
            melee: 10
            skills: [{name: skills.improvedMelee, level: 1}]
        cost: 500
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard long sword.'

    elvenSword:
        name: 'elven sword'
        min: 4.5
        max: 6.5
        range: 1
        attackType: attackTypes.melee
        requirements:
            level: 20
            melee: 20
            skills: [{name: skills.advancedMelee, level: 1}]
        cost: 2000
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Long sword crafted for elven warriors.'

    orcishSword:
        name: 'orcish sabre'
        min: 5
        max: 8
        range: 1
        attackType: attackTypes.melee
        requirements:
            level: 20
            melee: 20
            skills: [{name: skills.advancedMelee, level: 1}]
        cost: 2500
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Sabre used by brutish orcs.'

for key, sword of swords
    sword.init = (sword) ->
        chance = random(5) + 1
        description = sword.description + ' (critical chance ' + chance + '%)'
        modifier = () -> if random() < chance then return [weaponStates.critical] else return []
        return Object.assign {}, sword, { description: description, modifier: modifier }

module.exports = swords
