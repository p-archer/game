chalk = require 'chalk'

{ log, random, err } = require '../general'
{ attackTypes, armourTypes, XP_GAIN_FACTOR } = require '../constants'

armours =
    robe:
        name: 'robe'
        type: armourTypes.light
        cost: 100
        resistance:
            melee: 10
            ranged: 10
            magic: 50
    leather:
        name: 'leather armour'
        type: armourTypes.medium
        cost: 200
        resistance:
            melee: 50
            ranged: 30
            magic: 10
    breastPlate:
        name: 'breast plate'
        type: armourTypes.heavy
        cost: 400
        resistance:
            melee: 100
            ranged: 75
            magic: 20

soakDamage = (armour, damage, attackType) ->
    if attackType is attackTypes.pure
        return damage

    amount = armour.resistance[attackType]
    percentage = 1 / (1 + (amount / 100))

    return damage * percentage

getAll = () ->
    return armours

create = (armour) ->
    newArmour =
        name: armour.name
        type: armour.type
        resistance:
            melee: armour.resistance.melee
            ranged: armour.resistance.ranged
            magic: armour.resistance.magic

    return Object.freeze newArmour

module.exports =
    create: create
    getAll: getAll
    soakDamage: soakDamage
