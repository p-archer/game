chalk = require 'chalk'
{ attackTypes, weaponTypes, weaponStates } = require '../constants'
{ random, log, err, getPercent } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        arrow = actor.quiver[actor.arrow]
        broadhead = actor.broadheads[actor.broadhead]
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100)) * arrow.damage * broadhead.damage
        range = weapon.range * arrow.range * broadhead.range
        if distance > 1
            cth = 1 - Math.max 0, (distance/range - 1)
            if random() < cth * 100 then return damage else err '> ranged attack missed'
            return 0
        else
            pointBlankShot = actor.skills.pointBlankShot
            meleePenality = if pointBlankShot? then 0.5 - (pointBlankShot.level * pointBlankShot.bonus) else 0.5
            log chalk.yellow '> ranged attack at point-blank range (damage reduction: ' + chalk.redBright((meleePenality * 100).toFixed(2) + '%') + ')'
            return (1 - meleePenality) * damage

showCombat = (source, getDamageStr, distance) ->
    arrow = source.quiver[source.arrow]
    broadhead = source.broadheads[source.broadhead]
    range = source.weapon.range * arrow.range * broadhead.range

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
    log '\trange: ' +  getPercent(arrow.range * broadhead.range) + ' (' + chalk.green(range.toFixed(0)) + ') damage: ' + getPercent(arrow.damage * broadhead.damage) + ' (' + chalk.green(getDamageStr(source)) + ')'
    log '\tarrow: ' + arrow.description()
    log '\tbroadhead: ' + broadhead.description()
    log()
    if source.quiver.length > 1
        log '1\tswitch arrow type'
    if source.broadheads.length > 1
        log '2\tswitch broadheads'
    return

bows =
    shortBow:
        name: 'short bow'
        min: 1
        max: 4
        range: 20
        attackType: attackTypes.ranged
        requirements:
            level: 0
        cost: 100
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Basic short bow.'

    boneBow:
        name: 'bone bow'
        min: 2
        max: 3.5
        range: 24
        attackType: attackTypes.ranged
        requirements:
            level: 5
            mastery: 5
            skills: [{skill: skills.ranged, level: 2}]
        cost: 100
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Bow made out of wood and bone.'

    huntingBow:
        name: 'hunting bow'
        min: 3
        max: 4
        range: 18
        attackType: attackTypes.ranged
        requirements:
            level: 5
            mastery: 5
            skills: [{skill: skills.ranged, level: 3}]
        cost: 150
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Bow used by hunters. Sacrifices range for damage.'

    longBow:
        name: 'long bow'
        min: 2
        max: 5
        range: 25
        attackType: attackTypes.ranged
        requirements:
            level: 10
            mastery: 10
            skills: [{skill: skills.improvedRanged, level: 1}]
        cost: 500
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard long bow.'

    dwarvenBow:
        name: 'dwarven bow'
        min: 4.0
        max: 5.0
        range: 22
        attackType: attackTypes.ranged
        requirements:
            level: 13
            mastery: 10
            skills: [{skill: skills.improvedRanged, level: 3}]
        cost: 700
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Bow made by dwarven weaponsmiths.'

    blackBow:
        name: 'black bow'
        min: 3.0
        max: 4.5
        range: 28
        attackType: attackTypes.ranged
        requirements:
            level: 12
            mastery: 10
            skills: [{skill: skills.improvedRanged, level: 2}]
        cost: 700
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'A nimble long bow used to hunt down prey from a distance.'

    recurveBow:
        name: 'recurve bow'
        min: 3
        max: 6
        range: 28
        attackType: attackTypes.ranged
        requirements:
            level: 25
            mastery: 25
            skills: [{skill: skills.advancedRanged, level: 1}]
        cost: 1500
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard recurve bow.'

    elvenBow:
        name: 'elven bow'
        min: 4
        max: 5.5
        range: 32
        attackType: attackTypes.ranged
        requirements:
            level: 25
            mastery: 25
            skills: [{skill: skills.advancedRanged, level: 2}]
        cost: 2000
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Recurve bow made by elven master smiths.'


    orcishBow:
        name: 'orcish bow'
        min: 4.5
        max: 6
        range: 25
        attackType: attackTypes.ranged
        requirements:
            level: 25
            mastery: 25
            skills: [{skill: skills.advancedRanged, level: 3}]
        cost: 2000
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Recurve bow used by orcish chieftains.'

    reflexBow:
        name: 'reflex bow'
        min: 6.5
        max: 9
        range: 30
        attackType: attackTypes.ranged
        requirements:
            level: 40
            mastery: 40
            skills: [{skill: skills.advancedRanged, level: 5}]
        cost: 5000
        quality: 4
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard reflex bow.'

for key, bow of bows
    bow.init = (weapon) ->
        chance = random(5) + 1
        description = weapon.description + ' (critical chance ' + chance + '%)'
        modifier = () -> if random() < chance then return [ { effect: weaponStates.critical, ticks: 1} ] else return []

        return Object.assign {}, weapon, { description: description, modifier: modifier, showCombat: showCombat, type: weaponTypes.bow }

module.exports = bows
