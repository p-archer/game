chalk = require 'chalk'

{ log, random, err } = require '../general'
{ attackTypes, armourTypes, XP_GAIN_FACTOR } = require '../constants'

armours =
    fur:
        name: 'fur'
        monsterOnly: true
        type: armourTypes.light
        resistance:
            physical: 10
    skin:
        name: 'hardened skin'
        monsterOnly: true
        type: armourTypes.medium
        resistance:
            physical: 20
    scales:
        name: 'scales'
        monsterOnly: true
        type: armourTypes.heavy
        resistance:
            physical: 50
    robe:
        name: 'robe'
        type: armourTypes.light
        cost: 100
        resistance:
            physical: 10
    leather:
        name: 'leather armour'
        type: armourTypes.medium
        cost: 200
        resistance:
            physical: 20
    breastPlate:
        name: 'breast plate'
        type: armourTypes.heavy
        cost: 400
        resistance:
            physical: 50

soakDamage = (armour, damages) ->
    results = [damages...]
    for damage in results
        if damage.type is attackTypes.pure
            continue

        if not armour.resistance[damage.type]
            continue

        damage.amount *= (100 - armour.resistance[damage.type])/100

    return results

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
            lightning: armour.resistance.lightning || 0
            poison: armour.resistance.poison || 0
            dark: armour.resistance.dark || 0
            arcane: armour.resistance.arcane || 0

    return Object.freeze newArmour

module.exports =
    create: create
    getAll: getAll
    soakDamage: soakDamage
