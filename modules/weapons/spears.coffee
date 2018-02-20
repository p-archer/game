chalk = require 'chalk'
{ attackTypes, heroStates, weaponTypes, weaponStates } = require '../constants'
{ random, log, getPercent, err } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        arrow = actor.quiver[actor.arrow]
        broadhead = actor.broadheads[actor.broadhead]
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100)) * arrow.damage
        attack = broadhead.use damage
        range = weapon.range * arrow.range * broadhead.range

        if distance > 1
            cth = 1 - Math.max 0, (distance/weapon.range - 1)
            if random() < cth * 100
                return attack

            err '> ranged attack missed'
            return [ [ amount: 0, type: attackTypes.pure ], [] ]

        return attack

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
    log '\tusing ' + chalk.yellow(arrow.name + ' shaft') + ' with ' + chalk.yellow(broadhead.name + ' spearhead')
    log '\trange: ' +  getPercent(arrow.range * broadhead.range) + ' (' + chalk.green(range.toFixed(0)) + ') damage: ' + getPercent(damage) + ' (' + chalk.green(getDamageStr(source)) + ')'
    log '\tshaft: ' + arrow.description()
    log '\tspearhead: ' + broadhead.description()
    log()
    if source.quiver.length > 1
        log '1\tswitch shaft type'
    if source.broadheads.length > 1
        log '2\tswitch spearhead'
    return

spears =
    shortSpear:
        name: 'short spear'
        min: 2
        max: 3
        range: 10
        requirements:
            level: 0
        cost: 100
        quality: 1
        description: 'Short spear used for throwing.'

    pilum:
        name: 'pilum'
        min: 2
        max: 3
        range: 16
        requirements:
            level: 5
            skills: [{skill: skills.ranged, level: 3}]
        cost: 150
        quality: 1
        description: 'Roman pilum used in ranged combat.'

    javelin:
        name: 'javelin'
        min: 2.5
        max: 3
        range: 14
        requirements:
            level: 5
            skills: [{skill: skills.ranged, level: 2}]
        cost: 100
        quality: 1
        description: 'Standard javelin.'

    spear:
        name: 'spear'
        min: 3.5
        max: 5
        range: 12
        requirements:
            level: 10
            skills: [{skill: skills.improvedRanged, level: 1}]
        cost: 500
        quality: 2
        description: 'Spear used for throwing.'

    boneSpear:
        name: 'bone spear'
        min: 3
        max: 5
        range: 16
        requirements:
            level: 10
            skills: [{skill: skills.improvedRanged, level: 2}]
        cost: 700
        quality: 2
        description: 'A spear made out of bones. Increased range at the cost of damage.'

    longSpear:
        name: 'long spear'
        min: 4.5
        max: 6.0
        range: 10
        requirements:
            level: 20
            skills: [{skill: skills.advancedRanged, level: 1}]
        cost: 2000
        quality: 3
        description: 'Longer version of the spear, shorter range, but increased damage.'

for key, spear of spears
    spear.init = (spear) ->
        chance = (random(1000) + 1) / 100
        description = spear.description + ' (chance to maim ' + chance.toFixed(2) + '%)'
        modifier = () -> if random(10000) < chance * 100 then return [ { effect: heroStates.maimed, ticks: 1} ] else return []
        return Object.assign {}, spear, { description: description, modifier: modifier, showCombat: showCombat, type: weaponTypes.spear, getDamage: getDamage(spear) }

module.exports = spears
