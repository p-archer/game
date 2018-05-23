chalk = require 'chalk'
{ attackTypes, weaponTypes, weaponStates, speed } = require '../constants'
{ random, log, err, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        arrow = actor.quiver[actor.arrow]
        broadhead = actor.broadheads[actor.broadhead]
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100)) * arrow.damage
        attack = broadhead.use damage
        range = weapon.range * arrow.range * broadhead.range

        cth = 1 - Math.max 0, (distance/range - 1)
        if random() < cth * 100
            return attack

        err '> ranged attack missed'
        return [ [ amount: 0, type: attackTypes.pure ], [] ]

showCombat = (source, getDamageStr, distance) ->
    arrow = source.quiver[source.arrow]
    broadhead = source.broadheads[source.broadhead]
    range = source.weapon.range * arrow.range * broadhead.range
    damage = arrow.damage * broadhead.damage.reduce (a, x) ->
        return a + x.ratio
    , 0

    cth = 1 - Math.max 0, (distance/range - 1)
    cthStr = ''
    if cth is 1 then cthStr = chalk.green '100%'
    if cth < 1 and cth >= 0.8 then cthStr = chalk.yellow (cth*100).toFixed(0) + '%'
    if cth < 0.8 then cthStr = chalk.redBright (cth*100).toFixed(0) + '%'

    name = source.weapon.name
    if source.weapon.prefix? then name = source.weapon.prefix.name + ' ' + name
    if source.weapon.suffix? then name = name + ' of ' + source.weapon.suffix.name
    log 'e\tattack with ' + chalk.blueBright(name) + ' chance to hit: ' + cthStr
    log '\tusing ' + chalk.yellow(arrow.name + ' arrow') + ' with ' + chalk.yellow(broadhead.name + ' broadhead')
    log '\trange: ' +  getPercent(arrow.range * broadhead.range) + ' (' + chalk.green(range.toFixed(0)) + ') damage: ' + getPercent(damage) + ' (' + chalk.green(getDamageStr(source)) + ')'
    log '\tarrow: ' + arrow.description()
    log '\tbroadhead: ' + broadhead.description()
    log()
    if source.quiver.length > 1
        log '1\tswitch arrow type'
    if source.broadheads.length > 1
        log '2\tswitch broadheads'
    return

bows =
    fireSpit:
        name: 'fire spit'
        monsterOnly: true
    dart:
        name: 'dart'
        monsterOnly: true

    shortBow:
        name: 'short bow'
        min: 1.5
        max: 3
        speed: speed.fast
        range: 20
        requirements:
            level: 0
        cost: 100
        quality: 1
    boneBow:
        name: 'bone bow'
        min: 1.5
        max: 2.5
        speed: speed.vfast
        range: 16
        requirements:
            level: 5
            skills: [{skill: skills.ranged, level: 2}]
        cost: 100
        quality: 1
    huntingBow:
        name: 'hunting bow'
        min: 3
        max: 4
        speed: speed.normal
        range: 24
        requirements:
            level: 5
            skills: [{skill: skills.ranged, level: 3}]
        cost: 150
        quality: 1
    longBow:
        name: 'long bow'
        min: 3
        max: 6
        speed: speed.normal
        range: 26
        requirements:
            level: 10
            skills: [{skill: skills.improvedRanged, level: 1}]
        cost: 500
        quality: 2
    dwarvenBow:
        name: 'dwarven bow'
        min: 6.0
        max: 8.0
        speed: speed.slow
        range: 30
        requirements:
            level: 13
            skills: [{skill: skills.improvedRanged, level: 3}]
        cost: 700
        quality: 2
    blackBow:
        name: 'black bow'
        min: 3.0
        max: 4.5
        speed: speed.vfast
        range: 22
        requirements:
            level: 12
            skills: [{skill: skills.improvedRanged, level: 2}]
        cost: 700
        quality: 2
    recurveBow:
        name: 'recurve bow'
        min: 4.5
        max: 7
        speed: speed.normal
        range: 26
        requirements:
            level: 25
            skills: [{skill: skills.advancedRanged, level: 1}]
        cost: 1500
        quality: 3
    elvenBow:
        name: 'elven bow'
        min: 4
        max: 5.5
        speed: speed.fast
        range: 26
        requirements:
            level: 25
            skills: [{skill: skills.advancedRanged, level: 2}]
        cost: 2000
        quality: 3
    orcishBow:
        name: 'orcish bow'
        min: 5.5
        max: 8
        speed: speed.slow
        range: 32
        requirements:
            level: 25
            skills: [{skill: skills.advancedRanged, level: 3}]
        cost: 2000
        quality: 3
    battleBow:
        name: 'battle bow'
        min: 5
        max: 7
        speed: speed.fast
        range: 28
        requirements:
            level: 40
            skills: [{skill: skills.masterRanged, level: 1}]
        cost: 6000
        quality: 4
    reflexBow:
        name: 'reflex bow'
        min: 7.5
        max: 10
        speed: speed.slow
        range: 36
        requirements:
            level: 40
            skills: [{skill: skills.masterRanged, level: 1}]
        cost: 5000
        quality: 4

for key, bow of bows
    bow.init = (weapon) ->
        chance = (random(500) + 1) / 100
        description = 'critical chance ' + chance.toFixed(2) + '%'
        modifier = () -> if random(10000) < chance * 100 then return [ { effect: weaponStates.critical, ticks: 1} ] else return []

        return Object.assign {}, weapon, { description: description, modifier: modifier, showCombat: showCombat, type: weaponTypes.bow, getDamage: getDamage(weapon) }

module.exports = bows
