chalk = require 'chalk'

{ log, random, err } = require '../general'
{ attackTypes, armourTypes, XP_GAIN_FACTOR } = require '../constants'

armours =
    robe:
        name: 'robe'
        type: armourTypes.light
        cost: 100
        resistance:
            physical: 20
    leather:
        name: 'leather armour'
        type: armourTypes.medium
        cost: 200
        resistance:
            physical: 50
    breastPlate:
        name: 'breast plate'
        type: armourTypes.heavy
        cost: 400
        resistance:
            physical: 100

soakDamage = (armour, damages) ->
    sum = 0
    for damage in damages
        if damage.type is attackTypes.pure
            sum += damage.amount
            continue

        if not armour.resistance[damage.type]
            sum += damage.amount
            continue

        if damage.type is attackTypes.physical
            amount = armour.resistance.physical
            percentage = 1/(1+(amount/100))
            sum += percentage * damage.amount
            continue

        sum += damage.amount * armour.resistance[damage.type]

    return sum

getAll = () ->
    return armours

create = (armour) ->
    newArmour =
        name: armour.name
        type: armour.type
        resistance:
            physical: armour.resistance.physical || 0
            fire: armour.resistance.fire || 0
            ice: armour.resistance.ice || 0
            ligtning: armour.resistance.ligtning || 0
            poison: armour.resistance.poison || 0
            dark: armour.resistance.dark || 0
            arcane: armour.resistance.arcane || 0

    return Object.freeze newArmour

module.exports =
    create: create
    getAll: getAll
    soakDamage: soakDamage
