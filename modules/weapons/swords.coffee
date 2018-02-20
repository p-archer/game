chalk = require 'chalk'
{ attackTypes, weaponTypes, weaponStates } = require '../constants'
{ random, log, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return (actor) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        return [ [{ amount: damage, type: attackTypes.physical }], [] ]

showCombat = (source, getDamageStr) ->
    name = source.weapon.name
    if source.weapon.prefix? then name = source.weapon.prefix.name + ' ' + name
    if source.weapon.suffix? then name = name + ' of ' + source.weapon.suffix.name
    log 'e\tattack with ' + chalk.blueBright(name) + ' (' + getDamageStr(hero) + ')'
    log()
    return

swords =
    shortSword:
        name: 'short sword'
        min: 3
        max: 4
        requirements:
            level: 0
            skills: []
        cost: 100
        quality: 1
        description: 'Standard short sword.'

    scimitar:
        name: 'scimitar'
        min: 3
        max: 4.5
        requirements:
            level: 0
            skills: []
        cost: 120
        quality: 1
        description: 'Scimitar made from high quality steel.'

    broadSword:
        name: 'broad sword'
        min: 5.5
        max: 6.5
        requirements:
            level: 12
            skills: [{name: skills.improvedMelee, level: 3}]
        cost: 800
        quality: 2
        description: 'Sword with a broad blade.'

    longSword:
        name: 'long sword'
        min: 4.5
        max: 6
        requirements:
            level: 10
            skills: [{name: skills.improvedMelee, level: 1}]
        cost: 500
        quality: 2
        description: 'Standard long sword.'

    elvenSword:
        name: 'elven sword'
        min: 5.5
        max: 7.5
        requirements:
            level: 20
            skills: [{name: skills.advancedMelee, level: 1}]
        cost: 2000
        quality: 3
        description: 'Long sword crafted for elven warriors.'

    orcishSword:
        name: 'orcish sabre'
        min: 6
        max: 9
        requirements:
            level: 20
            skills: [{name: skills.advancedMelee, level: 1}]
        cost: 2500
        quality: 3
        description: 'Sabre used by brutish orcs.'

for key, sword of swords
    sword.init = (sword) ->
        chance = (random(500) + 1) / 100
        description = sword.description + ' (critical chance ' + chance + '%)'
        modifier = () -> if random(10000) < chance * 100 then return [ { effect: weaponStates.critical, ticks: 1} ] else return []

        return Object.assign {}, sword, { description: description, modifier: modifier, showCombat: showCombat, type: weaponTypes.sword , getDamage: getDamage(sword), range: 1 }

module.exports = swords
