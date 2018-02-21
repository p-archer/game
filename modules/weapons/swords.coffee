chalk = require 'chalk'
{ attackTypes, weaponTypes, weaponStates, speed } = require '../constants'
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
    log 'e\tattack with ' + chalk.blueBright(name) + ' (' + getDamageStr(source) + ')'
    log()
    return

swords =
    claws:
        name: 'claws'
        monsterOnly: true
        speed: speed.fast
    fangs:
        name: 'fangs'
        monsterOnly: true
        speed: speed.vfast
    fists:
        name: 'fists'
        monsterOnly: true
        speed: speed.fast

    shortSword:
        name: 'short sword'
        min: 1
        max: 2
        speed: speed.vfast
        requirements:
            level: 0
            skills: []
        cost: 100
        quality: 1
        description: 'Standard short sword.'

    scimitar:
        name: 'scimitar'
        min: 1
        max: 2.5
        speed: speed.vfast
        requirements:
            level: 0
            skills: []
        cost: 120
        quality: 1
        description: 'Scimitar made from high quality steel.'

    broadSword:
        name: 'broad sword'
        min: 2.5
        max: 3.5
        speed: speed.fast
        requirements:
            level: 12
            skills: [{name: skills.improvedMelee, level: 3}]
        cost: 800
        quality: 2
        description: 'Sword with a broad blade.'

    longSword:
        name: 'long sword'
        min: 2.5
        max: 4
        speed: speed.fast
        requirements:
            level: 10
            skills: [{name: skills.improvedMelee, level: 1}]
        cost: 500
        quality: 2
        description: 'Standard long sword.'

    elvenSword:
        name: 'elven sword'
        min: 2.5
        max: 3.5
        speed: speed.vfast
        requirements:
            level: 20
            skills: [{name: skills.advancedMelee, level: 1}]
        cost: 2000
        quality: 3
        description: 'Long sword crafted for elven warriors.'

    orcishSword:
        name: 'orcish sabre'
        min: 4
        max: 6
        speed: speed.normal
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
