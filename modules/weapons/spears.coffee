chalk = require 'chalk'
{ attackTypes, weaponStates } = require '../constants'
{ random, log } = require '../general'

skills = require '../skills/skills.coffee'
    .getNames()

getDamage = (weapon) ->
    return (actor, distance) ->
        damage = (weapon.min + (random() * (weapon.max - weapon.min) / 100))
        if distance > 1
            cth = 1 - Math.max 0, (distance/weapon.range - 1)
            if cth < 1 then log chalk.yellow ' -- enemy outside optimal range (chance to hit: ' + chalk.redBright((cth*100).toFixed(0) + '%') + ')'
            if random() < cth * 100 then return damage else return 0
        else
            return damage

spears =
    shortSpear:
        name: 'short spear'
        min: 2
        max: 5
        range: 10
        attackType: attackTypes.ranged
        requirements:
            level: 0
        cost: 100
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Short spear used for throwing.'

    pilum:
        name: 'pilum'
        min: 2.5
        max: 3.5
        range: 16
        attackType: attackTypes.ranged
        requirements:
            level: 5
            ranged: 5
            skills: [{name: skills.ranged, level: 3}]
        cost: 150
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Roman pilum used in ranged combat.'

    javelin:
        name: 'javelin'
        min: 2
        max: 4
        range: 14
        attackType: attackTypes.ranged
        requirements:
            level: 5
            ranged: 5
            skills: [{name: skills.ranged, level: 2}]
        cost: 100
        quality: 1
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Standard javelin.'

    spear:
        name: 'spear'
        min: 3.5
        max: 6.5
        range: 12
        attackType: attackTypes.ranged
        requirements:
            level: 10
            ranged: 10
            skills: [{name: skills.improvedRanged, level: 1}]
        cost: 500
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Spear used for throwing.'

    boneSpear:
        name: 'bone spear'
        min: 3
        max: 5.5
        range: 16
        attackType: attackTypes.ranged
        requirements:
            level: 10
            ranged: 10
            skills: [{name: skills.improvedRanged, level: 2}]
        cost: 700
        quality: 2
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'A spear made out of bones. Increased range at the cost of damage.'

    longSpear:
        name: 'long spear'
        min: 4.5
        max: 8.0
        range: 10
        attackType: attackTypes.ranged
        requirements:
            level: 20
            ranged: 20
            skills: [{name: skills.advancedRanged, level: 1}]
        cost: 2000
        quality: 3
        getDamage: (x...) -> getDamage(this)(x...)
        description: 'Longer version of the spear, shorter range, but increased damage.'

for key, spear of spears
    spear.init = (spear) ->
        chance = random(5) + 1
        description = spear.description + ' (chance to maim ' + chance + '%)'
        modifier = () -> if random() < chance then return [ weaponStates.maiming ] else return []
        return Object.assign {}, spear, { description: description, modifier: modifier }

module.exports = spears
